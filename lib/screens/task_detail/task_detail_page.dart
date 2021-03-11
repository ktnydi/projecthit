import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/screens/invite_task_member/invite_task_member_page.dart';
import 'package:projecthit/screens/task_detail/task_detail_model.dart';
import 'package:provider/provider.dart';

class TaskDetail extends StatelessWidget {
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _descriptionKey = GlobalKey<FormFieldState<String>>();
  final Project project;
  final Task task;

  TaskDetail({@required this.project, @required this.task});

  Future<void> _updateTask(BuildContext context, Task task) async {
    if (!_nameKey.currentState.validate()) return;

    final taskDetailModel = context.read<TaskDetailModel>();

    try {
      taskDetailModel.beginLoading();
      await taskDetailModel.updateTask(
        project: project,
        task: task,
      );
      taskDetailModel.endLoading();
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
                    onPressed: () {
                      // TODO: タスク削除
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
                                return InviteTaskMember();
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
                      onFieldSubmitted: (value) async {
                        if (task.name == value) return;

                        task.name = value;

                        await _updateTask(context, task);
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description',
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
                                  color:
                                      Theme.of(context).textTheme.caption.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Switch.adaptive(
                          value: context.select(
                            (TaskDetailModel model) => model.isActiveDateTime,
                          ),
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (isActive) {
                            taskDetailModel.isActiveDateTime = isActive;

                            if (isActive) {
                              taskDetailModel.deadlineController.text =
                                  DateFormat('dd, MMM yyyy').format(
                                DateTime.now(),
                              );
                              task.expiredAt =
                                  Timestamp.fromDate(DateTime.now());
                            } else {
                              task.expiredAt = null;
                              taskDetailModel.deadlineController.clear();
                            }

                            taskDetailModel.reload();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: taskDetailModel.deadlineController,
                      validator: (value) {
                        if (!taskDetailModel.isActiveDateTime) return null;

                        if (value.trim().isEmpty) {
                          return 'Select deadline';
                        }

                        return null;
                      },
                      readOnly: true,
                      enabled: context.select(
                        (TaskDetailModel model) => model.isActiveDateTime,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: taskDetailModel.isActiveDateTime
                            ? 'Select date'
                            : 'No deadline',
                      ),
                      onTap: () async {
                        final currentDate = DateTime.now();
                        final dateTime = await showDatePicker(
                          context: context,
                          initialDate: task.expiredAt?.toDate() ?? currentDate,
                          firstDate: currentDate,
                          lastDate: currentDate.add(Duration(days: 365)),
                        );
                        if (dateTime == null) return;
                        task.expiredAt = Timestamp.fromDate(dateTime);
                        final formatDate =
                            DateFormat('dd, MMM yyyy').format(dateTime);
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
