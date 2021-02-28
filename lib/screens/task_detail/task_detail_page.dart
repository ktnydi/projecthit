import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projecthit/screens/task_detail/task_detail_model.dart';
import 'package:provider/provider.dart';

class TaskDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String name = '';
    String description = '';
    DateTime deadline;

    return ChangeNotifierProvider<TaskDetailModel>(
      create: (_) => TaskDetailModel(),
      builder: (context, child) {
        final taskDetailModel = context.read<TaskDetailModel>();

        return Scaffold(
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
                        // TODO: メンバー追加
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
                  initialValue: name,
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
                  onChanged: (value) {
                    name = value;
                  },
                  onFieldSubmitted: (value) {
                    // TODO: タスク名変更処理
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
                  initialValue: description,
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
                  onChanged: (value) {
                    description = value;
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
                              color: Theme.of(context).textTheme.caption.color,
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
                      onChanged: (isActive) {
                        taskDetailModel.isActiveDateTime = isActive;

                        if (isActive) {
                          deadline = DateTime.now();
                          taskDetailModel.deadlineController.text =
                              DateFormat('dd, MMM yyyy').format(
                            DateTime.now(),
                          );
                        } else {
                          deadline = null;
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
                      initialDate: deadline ?? currentDate,
                      firstDate: currentDate,
                      lastDate: currentDate.add(Duration(days: 365)),
                    );

                    if (dateTime == null) return;

                    deadline = dateTime;
                    taskDetailModel.reload();
                    final formatDate =
                        DateFormat('dd, MMM yyyy').format(dateTime);
                    taskDetailModel.deadlineController.text = formatDate;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
