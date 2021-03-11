import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/screens/add_task/add_task_page.dart';
import 'package:projecthit/screens/invite_member/invite_member_page.dart';
import 'package:projecthit/screens/project_detail/project_detail_page.dart';
import 'package:projecthit/screens/task_detail/task_detail_page.dart';
import 'package:projecthit/screens/task_list/task_list_model.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  final Project project;

  TaskList({@required this.project});

  Future<void> _doneTask(BuildContext context, Task task) async {
    final taskListModel = context.read<TaskListModel>();

    try {
      task.isDone = !task.isDone;
      await taskListModel.doneTask(task);
    } catch (e) {
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
    return ChangeNotifierProvider<TaskListModel>(
      create: (_) => TaskListModel(project: project),
      builder: (context, snapshot) {
        final taskListModel = context.read<TaskListModel>();

        return Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Name',
                ),
                Text(
                  '3 Members',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.person_add_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) => InviteMember(),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ProjectDetail(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: StreamBuilder(
            stream: taskListModel.fetchTasks(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Task>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      '${snapshot.error}',
                    ),
                  ),
                );
              }

              if (snapshot.data.isEmpty) {
                return SafeArea(
                  child: Center(
                    child: Text(
                      'None of tasks',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final task = snapshot.data[index];

                  return Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            OutlinedButton(
                              child: Icon(
                                Icons.circle,
                                size: task.isDone ? 24 : 0,
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(34, 34),
                              ),
                              onPressed: () async {
                                await _doneTask(context, task);
                              },
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${task.name}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          decoration: task.isDone
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    task.expiredAt != null
                                        ? '${task.expiredAt}'
                                        : 'No deadline',
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
                            if (task.sumUsers > 0)
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: Icon(Icons.face_outlined),
                              ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetail(),
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: snapshot.data.length,
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddTask(project: project),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
