import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/extension/date_time.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/task_detail/task_detail_model.dart';
import 'package:provider/provider.dart';

class TaskDetail extends StatelessWidget {
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _descriptionKey = GlobalKey<FormFieldState<String>>();
  final _deadlineKey = GlobalKey<FormFieldState<String>>();
  final Project project;
  final Task task;

  TaskDetail({@required this.project, @required this.task});

  Future<void> _updateTask(BuildContext context, Task task) async {
    if (!_nameKey.currentState.validate()) return;
    if (!_descriptionKey.currentState.validate()) return;
    if (!_deadlineKey.currentState.validate()) return;

    final name = _nameKey.currentState.value;
    final description = _descriptionKey.currentState.value;
    final deadline = _deadlineKey.currentState.value;
    final expiredAt = deadline.isNotEmpty
        ? Timestamp.fromDate(DateTime.parse(deadline))
        : null;

    task.name = name;
    task.description = description;
    task.expiredAt = expiredAt;

    FocusScope.of(context).unfocus();

    final taskDetailModel = context.read<TaskDetailModel>();

    try {
      taskDetailModel.beginLoading();
      await taskDetailModel.updateTask(
        project: project,
        task: task,
      );
      taskDetailModel.endLoading();
      Navigator.pop(context);
    } catch (e) {
      taskDetailModel.endLoading();
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
  }

  Future<void> _deleteTask(
    BuildContext context,
    TaskDetailModel taskDetailModel,
  ) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content:
              Text('Delete this task. Can\'t recover deleted tasks later.'),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('DELETE'),
              onPressed: () async {
                Navigator.pop(context);

                try {
                  taskDetailModel.beginLoading();
                  await taskDetailModel.deleteTask(
                    project: project,
                    task: task,
                  );
                  taskDetailModel.endLoading();
                  Navigator.pop(context);
                } catch (e) {
                  taskDetailModel.endLoading();
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
        );
      },
    );
  }

  Future<DateTime> _showDeadlinePicker(BuildContext context) {
    final taskDetailModel = context.read<TaskDetailModel>();
    final currentDate = DateTime.now();

    return showDatePicker(
      context: context,
      initialDate: taskDetailModel.deadlineController.text.isNotEmpty
          ? DateTime.parse(taskDetailModel.deadlineController.text)
          : currentDate,
      firstDate: currentDate,
      lastDate: DateTime.parse('${currentDate.year + 11}-12-31'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskDetailModel>(
      create: (_) => TaskDetailModel(project, task),
      builder: (context, child) {
        final taskDetailModel = context.read<TaskDetailModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.delete_outlined),
                    onPressed: () async {
                      await _deleteTask(context, taskDetailModel);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      await _updateTask(context, task);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final projectUsers = context.select(
                          (TaskDetailModel model) => model.projectUsers,
                        );

                        final widgets = projectUsers.map(
                          (projectUser) {
                            return _ProjectUser(projectUser);
                          },
                        ).toList();

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: widgets,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Task Name',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      key: _nameKey,
                      initialValue: task.name,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter task name';
                        }

                        if (value.length > 100) {
                          return 'Task name is too long';
                        }

                        return null;
                      },
                      maxLength: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description (optional)',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      key: _descriptionKey,
                      initialValue: task.description,
                      validator: (value) {
                        if (value.length > 140) {
                          return 'Description is too long';
                        }

                        return null;
                      },
                      maxLines: 5,
                      maxLength: 140,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Deadline (optional)',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      key: _deadlineKey,
                      focusNode: taskDetailModel.focusNode,
                      controller: taskDetailModel.deadlineController
                        ..text = task.expiredAt?.toDate()?.format() ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'yyyy-mm-dd',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            taskDetailModel.focusNode.unfocus();

                            taskDetailModel.focusNode.canRequestFocus = false;

                            taskDetailModel.deadlineController.clear();
                          },
                        ),
                      ),
                      onTap: () async {
                        if (!taskDetailModel.focusNode.canRequestFocus) {
                          return;
                        }

                        final dateTime = await _showDeadlinePicker(context);
                        if (dateTime == null) return;
                        final formatDate = dateTime.format();
                        taskDetailModel.deadlineController.text = formatDate;
                      },
                    ),
                  ],
                ),
              ),
            ),
            context.select((TaskDetailModel model) => model.isLoading)
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

class _ProjectUserLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: Icon(Icons.face_outlined),
              ),
              Material(
                elevation: 1,
                shape: CircleBorder(),
                color: Theme.of(context).dividerColor,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.check_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              'Loading...',
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectUser extends StatelessWidget {
  final ProjectUser projectUser;

  _ProjectUser(this.projectUser);

  @override
  Widget build(BuildContext context) {
    final taskDetailModel = context.read<TaskDetailModel>();

    return FutureBuilder<AppUser>(
      future: taskDetailModel.fetchUser(projectUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _ProjectUserLoading();
        }

        final appUser = snapshot.data;

        final projectTaskUserIds = context.select(
          (TaskDetailModel model) => model.projectTaskUserIds,
        );

        final isInclude = !projectTaskUserIds
            .indexWhere(
              (projectTaskUserId) => projectTaskUserId == appUser.id,
            )
            .isNegative;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              if (isInclude) {
                taskDetailModel.deselectUser(appUser);
                return;
              }

              taskDetailModel.selectUser(appUser);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: context.select(
                        (MyAppModel model) => model.currentAppUser.icon != null,
                      )
                          ? CachedNetworkImage(
                              imageUrl: context.select(
                                (MyAppModel model) => model.currentAppUser.icon,
                              ),
                              fit: BoxFit.cover,
                            )
                          : Text(
                              'Image',
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                            ),
                    ),
                    Material(
                      elevation: 1,
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white, width: 3),
                      ),
                      color: isInclude
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.check_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${appUser.name}',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
