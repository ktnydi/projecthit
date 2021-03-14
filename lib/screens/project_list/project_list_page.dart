import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/screens/add_project/add_project_page.dart';
import 'package:projecthit/screens/project_detail/project_detail_page.dart';
import 'package:projecthit/screens/project_list/project_list_model.dart';
import 'package:projecthit/screens/setting/setting_page.dart';
import 'package:projecthit/screens/task_list/task_list_page.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProjectListModel>(
      create: (_) => ProjectListModel(),
      builder: (context, child) {
        final projectListModel = context.read<ProjectListModel>();

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              'ProjectHit',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(OMIcons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Setting(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: StreamBuilder(
            stream: projectListModel.fetchProjectUsers(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<ProjectUser>> snapshot,
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
                    child: Text('${snapshot.error}'),
                  ),
                );
              }

              final projectUsers = snapshot.data;

              return ListView.separated(
                padding: EdgeInsets.all(16),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: projectListModel.fetchProject(projectUsers[index]),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Project> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text('${snapshot.error}'),
                            ),
                          ),
                        );
                      }

                      final project = snapshot.data;

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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${project.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${project.sumUsers} Members',
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
                                SizedBox(
                                  width: 32,
                                  child: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProjectDetail(project: project),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskList(
                                  project: project,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                itemCount: context.select(
                  (ProjectListModel model) => projectUsers.length,
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddProject(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
