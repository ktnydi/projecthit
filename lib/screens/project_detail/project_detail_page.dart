import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/entity/app_user.dart';
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
      create: (_) => ProjectDetailModel()..fetchProjectUsers(project),
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
                        AppLocalizations.of(context).projectUserFieldLabel,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 60,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Builder(
                                    builder: (context) {
                                      final member = context.select(
                                        (ProjectDetailModel model) =>
                                            model.projectUsers[index],
                                      );

                                      return FutureBuilder<AppUser>(
                                        future: projectDetailModel
                                            .fetchUser(member),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox();
                                          }

                                          final user = snapshot.data;

                                          return Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 1,
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                ),
                                              ],
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: user.icon != null
                                                ? CachedNetworkImage(
                                                    imageUrl: user.icon,
                                                  )
                                                : Text(
                                                    'Image',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .color,
                                                    ),
                                                  ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 8),
                                itemCount: context.select(
                                  (ProjectDetailModel model) =>
                                      model.projectUsers.length,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          OutlinedButton(
                            child: Icon(Icons.person_add_outlined),
                            style: OutlinedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(60, 60),
                            ),
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
                      SizedBox(height: 24),
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
