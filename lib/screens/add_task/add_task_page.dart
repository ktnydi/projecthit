import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/screens/add_task/add_task_model.dart';
import 'package:projecthit/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

class AddTask extends StatelessWidget {
  final Project project;

  AddTask({@required this.project});

  @override
  Widget build(BuildContext context) {
    String name = '';

    return ChangeNotifierProvider<AddTaskModel>(
      create: (_) => AddTaskModel(project: project),
      builder: (context, child) {
        final addTaskModel = context.read<AddTaskModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      if (name.trim().isEmpty) return;

                      FocusScope.of(context).unfocus();

                      try {
                        addTaskModel.beginLoading();
                        await addTaskModel.addTask(name: name);
                        addTaskModel.endLoading();

                        Navigator.pop(context);
                      } catch (e) {
                        addTaskModel.endLoading();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorDialog(
                              contentText: e.toString(),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).taskFieldLabel,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return AppLocalizations.of(context).presentError(
                            AppLocalizations.of(context).taskFieldLabel,
                          );
                        }

                        if (value.length > 100) {
                          return AppLocalizations.of(context)
                              .maximumTextLengthError(
                            AppLocalizations.of(context).taskFieldLabel,
                          );
                        }

                        return null;
                      },
                      autofocus: true,
                      maxLength: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            context.select((AddTaskModel model) => model.isLoading)
                ? Container(
                    color: Colors.white.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}
