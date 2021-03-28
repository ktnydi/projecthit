import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/extension/date_time.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/screens/add_task/add_task_page.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/project_detail/project_detail_page.dart';
import 'package:projecthit/screens/setting/setting_page.dart';
import 'package:projecthit/screens/task_detail/task_detail_page.dart';
import 'package:projecthit/screens/task_list/task_list_model.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  final Project project;

  TaskList({@required this.project});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<void> _doneTask(BuildContext context, Task task) async {
    final taskListModel = context.read<TaskListModel>();

    try {
      task.isDone = !task.isDone;
      if (task.isDone) HapticFeedback.selectionClick();
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

  Future<void> _deleteDoneTask(
    BuildContext context,
    TaskListModel taskListModel,
  ) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text(
              'Delete all done tasks. Can\'t recover deleted tasks later.'),
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
                  taskListModel.beginLoading();
                  await taskListModel.deleteDoneTask();
                  taskListModel.endLoading();
                } catch (e) {
                  taskListModel.endLoading();
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

  @override
  void initState() {
    super.initState();

    final myAppModel = context.read<MyAppModel>();

    Future(
      () async {
        await myAppModel.initCloudMessaging();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.of(context).viewPadding;

    double floatingButtonMargin = 16;

    if (viewPadding.bottom > 0) {
      floatingButtonMargin = viewPadding.bottom;
    }

    return ChangeNotifierProvider<TaskListModel>(
      create: (_) => TaskListModel(project: widget.project),
      builder: (context, snapshot) {
        final taskListModel = context.read<TaskListModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('${widget.project.name}'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () async {
                      await _deleteDoneTask(context, taskListModel);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetail(project: widget.project),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(OMIcons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => Setting(),
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
                                color:
                                    Theme.of(context).textTheme.caption.color,
                              ),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      floatingButtonMargin + 72,
                    ),
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size(34, 34),
                                  ),
                                  onPressed: () async {
                                    await _doneTask(context, task);
                                  },
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color: task.isDone
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .color
                                                  : null,
                                            ),
                                      ),
                                      if (task.expiredAt != null)
                                        SizedBox(height: 4),
                                      if (task.expiredAt != null)
                                        Text(
                                          '${task.expiredAt.toDate().format()}',
                                          style: TextStyle(
                                            color:
                                                task.isExpired && !task.isDone
                                                    ? Color(0xFFEF377A)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        .color,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                if (task.taskUserIds.isNotEmpty)
                                  _TaskUserIcon(task: task),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetail(
                                  project: widget.project,
                                  task: task,
                                ),
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
                      builder: (context) => AddTask(project: widget.project),
                    ),
                  );
                },
              ),
            ),
            context.select((TaskListModel model) => model.isLoading)
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

class _TaskUserIcon extends StatelessWidget {
  final Task task;

  _TaskUserIcon({@required this.task});

  @override
  Widget build(BuildContext context) {
    final taskListModel = context.read<TaskListModel>();

    return StreamBuilder<List<AppUser>>(
      stream: taskListModel.fetchTaskUsers(
        task.taskUserIds,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(),
              ],
            ),
            child: Icon(Icons.error_outline),
          );
        }

        final taskUsers = snapshot.data;

        final widgets = taskUsers.map(
          (user) {
            if (user.icon == null) {
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(),
                  ],
                ),
                child: Icon(Icons.face_outlined),
              );
            }

            return Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: user.icon,
                fit: BoxFit.cover,
              ),
            );
          },
        ).toList();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        );
      },
    );
  }
}
