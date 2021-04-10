import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/repository/project_repository.dart';
import 'package:projecthit/repository/task_repository.dart';
import 'package:projecthit/screens/invite_member/invite_member_page.dart';
import 'package:projecthit/screens/project_detail/project_detail_model.dart';
import 'package:projecthit/widgets/error_dialog.dart';
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
          return ErrorDialog(
            contentText: e.toString(),
          );
        },
      );
    }
  }

  Future<void> _deleteDoneTask(
    BuildContext context,
  ) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    final projectDetailModel = context.read<ProjectDetailModel>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).confirmDialogTitle),
          content: Text(AppLocalizations.of(context).confirmDeleteDoneTasks),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context).cancel.toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).delete.toUpperCase()),
              onPressed: () async {
                Navigator.pop(context);

                try {
                  projectDetailModel.beginLoading();
                  await projectDetailModel.deleteDoneTask(project);
                  projectDetailModel.endLoading();
                } catch (e) {
                  projectDetailModel.endLoading();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ErrorDialog(
                        contentText: e.toString(),
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProjectDetailModel>(
      create: (_) => ProjectDetailModel(
        projectRepository: context.read<ProjectRepository>(),
        taskRepository: context.read<TaskRepository>(),
      )..fetchProjectUsers(project),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
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
                    builder: (context) => InviteMember(
                      project: project,
                    ),
                  );
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
                        AppLocalizations.of(context).projectFieldLabel,
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
                            return AppLocalizations.of(context).presentError(
                              AppLocalizations.of(context).projectFieldLabel,
                            );
                          }

                          if (value.length > 50) {
                            return AppLocalizations.of(context)
                                .maximumTextLengthError(
                              AppLocalizations.of(context).projectFieldLabel,
                            );
                          }

                          return null;
                        },
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context).projectDescriptionLabel,
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
                            return AppLocalizations.of(context)
                                .maximumTextLengthError(
                              AppLocalizations.of(context)
                                  .projectDescriptionLabel,
                            );
                          }

                          return null;
                        },
                        maxLines: 5,
                        maxLength: 140,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context).projectUserFieldLabel,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final projectUsers = context.select(
                            (ProjectDetailModel model) => model.projectUsers,
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
                      SizedBox(height: 24),
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context).update),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                        ),
                        onPressed: () async {
                          await _updateProject(context);
                        },
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          child: Text('完了済みのタスクを削除'),
                          onPressed: () async {
                            await _deleteDoneTask(context);
                          },
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

class _ProjectUser extends StatelessWidget {
  final ProjectUser projectUser;

  _ProjectUser(this.projectUser);

  @override
  Widget build(BuildContext context) {
    final projectDetailModel = context.read<ProjectDetailModel>();

    return FutureBuilder<AppUser>(
      future: projectDetailModel.fetchUser(projectUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final appUser = snapshot.data;

        return Container(
          margin: EdgeInsets.only(right: 8),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: appUser.icon != null
                      ? CachedNetworkImage(
                          imageUrl: appUser.icon,
                          fit: BoxFit.cover,
                        )
                      : Text(
                          'Image',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                        ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${appUser.name}',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    strutStyle: StrutStyle(
                      fontSize: 16,
                      height: 1.3,
                    ),
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
