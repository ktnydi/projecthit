import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/extension/date_time.dart';
import 'package:projecthit/screens/invite_task_member/invite_task_member_page.dart';
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

    if (name == task.name &&
        description == task.description &&
        expiredAt == task.expiredAt) return;

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
      create: (_) => TaskDetailModel(),
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
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 44,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  child: Icon(Icons.face_outlined),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 8),
                              itemCount: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        OutlinedButton(
                          child: Icon(Icons.person_add_outlined),
                          style: OutlinedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: Theme.of(context).iconTheme.color,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size(44, 44),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return InviteTaskMember(
                                  project: project,
                                );
                              },
                            );
                          },
                        ),
                      ],
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
