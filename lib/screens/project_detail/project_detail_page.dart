import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/screens/invite_member/invite_member_page.dart';
import 'package:projecthit/screens/project_detail/project_detail_model.dart';
import 'package:provider/provider.dart';

class ProjectDetail extends StatelessWidget {
  final Project project;
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _descriptionKey = GlobalKey<FormFieldState<String>>();
  final _formKey = GlobalKey<FormState>();

  ProjectDetail({@required this.project});

  Future<void> _updateProject(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    final name = _nameKey.currentState.value;
    final description = _descriptionKey.currentState.value;

    if (name == project.name && description == project.description) return;

    FocusScope.of(context).unfocus();

    final projectDetailModel = context.read<ProjectDetailModel>();

    try {
      projectDetailModel.beginLoading();

      project.name = name;
      project.description = description;
      await projectDetailModel.updateProject(project: project);

      projectDetailModel.endLoading();

      Navigator.pop(context);
    } catch (e) {
      projectDetailModel.endLoading();

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

  Future<void> _confirmDeletingProject(
    BuildContext context,
    ProjectDetailModel projectDetailModel,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text(
              'Delete this project and related tasks. you can\'t recover deleted project later.'),
          actions: [
            TextButton(
              child: Text('cancel'.toUpperCase()),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('delete'.toUpperCase()),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteProject(context, projectDetailModel);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _deleteProject(
    BuildContext context,
    ProjectDetailModel projectDetailModel,
  ) async {
    try {
      projectDetailModel.beginLoading();
      await projectDetailModel.deleteProject(project: project);
      projectDetailModel.endLoading();

      Navigator.pop(context);
    } catch (e) {
      projectDetailModel.endLoading();
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
    return ChangeNotifierProvider<ProjectDetailModel>(
      create: (_) => ProjectDetailModel(),
      builder: (context, child) {
        final projectDetailModel = context.read<ProjectDetailModel>();

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () async {
                  await _confirmDeletingProject(context, projectDetailModel);
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  await _updateProject(context);
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
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
                                itemCount: 3,
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
                                builder: (context) => InviteMember(),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Project Name',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        key: _nameKey,
                        initialValue: project.name,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Enter project name';
                          }

                          if (value.length > 50) {
                            return 'Project name is too long';
                          }

                          return null;
                        },
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                        initialValue: project.description,
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
                    ],
                  ),
                ),
              ),
              context.select((ProjectDetailModel model) => model.isLoading)
                  ? Container(
                      color: Colors.white.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
