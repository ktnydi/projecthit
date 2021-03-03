import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projecthit/screens/add_project/add_project_model.dart';
import 'package:provider/provider.dart';

class AddProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    DateTime deadline;

    return ChangeNotifierProvider<AddProjectModel>(
      create: (_) => AddProjectModel(),
      builder: (context, child) {
        final addProjectModel = context.read<AddProjectModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;

                      FocusScope.of(context).unfocus();

                      try {
                        addProjectModel.beginLoading();
                        await addProjectModel.addProject(
                          name: name,
                          deadline: deadline,
                        );
                        addProjectModel.endLoading();
                        Navigator.pop(context);
                      } catch (e) {
                        addProjectModel.endLoading();
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
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Name',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Enter project name';
                          }

                          if (value.length > 50) {
                            return 'Project name is too long';
                          }

                          return null;
                        },
                        autofocus: true,
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Deadline',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'It will be send notification 3 days ago of deadline.',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Switch.adaptive(
                            value: context.select(
                              (AddProjectModel model) => model.isActiveDateTime,
                            ),
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            onChanged: (isActive) {
                              addProjectModel.isActiveDateTime = isActive;

                              if (isActive) {
                                deadline = DateTime.now();
                                addProjectModel.deadlineController.text =
                                    DateFormat('dd, MMM yyyy').format(
                                  DateTime.now(),
                                );
                              } else {
                                deadline = null;
                                addProjectModel.deadlineController.clear();
                              }

                              addProjectModel.reload();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: addProjectModel.deadlineController,
                        validator: (value) {
                          if (!addProjectModel.isActiveDateTime) return null;

                          if (value.trim().isEmpty) {
                            return 'Select deadline';
                          }

                          return null;
                        },
                        readOnly: true,
                        enabled: context.select(
                          (AddProjectModel model) => model.isActiveDateTime,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: addProjectModel.isActiveDateTime
                              ? 'Select date'
                              : 'No deadline',
                        ),
                        onTap: () async {
                          final currentDate = DateTime.now();
                          final dateTime = await showDatePicker(
                            context: context,
                            initialDate: deadline ?? currentDate,
                            firstDate: currentDate,
                            lastDate: currentDate.add(Duration(days: 365)),
                          );

                          if (dateTime == null) return;

                          deadline = dateTime;
                          addProjectModel.reload();
                          final formatDate =
                              DateFormat('dd, MMM yyyy').format(dateTime);
                          addProjectModel.deadlineController.text = formatDate;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.select((AddProjectModel model) => model.isLoading)
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
