import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/screens/add_task/add_task_model.dart';
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
                            return AlertDialog(
                              title: Text('Oops!'),
                              content: Text('$e'),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
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
                      'Task Name',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter task name';
                        }

                        if (value.length > 100) {
                          return 'Task name is too long';
                        }

                        return null;
                      },
                      autofocus: true,
                      maxLength: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
