import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/screens/invite_task_member/invite_task_member_model.dart';
import 'package:provider/provider.dart';

class InviteTaskMember extends StatelessWidget {
  final Project project;
  final Task task;

  InviteTaskMember({@required this.project, @required this.task});

  Future<void> _addProjectTaskUsers(BuildContext context) async {
    final inviteTaskMemberModel = context.read<InviteTaskMemberModel>();

    try {
      inviteTaskMemberModel.beginLoading();
      await inviteTaskMemberModel.addProjectTaskUsers(
        project,
        task,
      );
      inviteTaskMemberModel.endLoading();

      Navigator.pop(context);
    } catch (e) {
      inviteTaskMemberModel.endLoading();
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
    return ChangeNotifierProvider<InviteTaskMemberModel>(
      create: (_) => InviteTaskMemberModel(),
      builder: (context, child) {
        final inviteTaskMemberModel = InviteTaskMemberModel();

        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Invite task member',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 4),
                Text(
                  'Select members to invite',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                SizedBox(height: 16),
                StreamBuilder<List<ProjectUser>>(
                  stream: inviteTaskMemberModel.fetchProjectUser(project),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    final projectUsers = snapshot.data;

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
                Center(
                  child: ElevatedButton(
                    child: Text('Invite'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 44),
                    ),
                    onPressed: () async {
                      await _addProjectTaskUsers(context);
                    },
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

class _ProjectUser extends StatelessWidget {
  final ProjectUser projectUser;

  _ProjectUser(this.projectUser);

  @override
  Widget build(BuildContext context) {
    final inviteTaskMemberModel = context.read<InviteTaskMemberModel>();

    return FutureBuilder<AppUser>(
      future: inviteTaskMemberModel.fetchUser(projectUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        final appUser = snapshot.data;

        final projectTaskUsers = context.select(
          (InviteTaskMemberModel model) => model.projectTaskUsers,
        );

        final isInclude = !projectTaskUsers
            .indexWhere(
              (projectTaskUser) => projectTaskUser.id == appUser.id,
            )
            .isNegative;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              if (isInclude) {
                inviteTaskMemberModel.deselectUser(appUser);
                return;
              }

              inviteTaskMemberModel.selectUser(appUser);
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
                      color: isInclude
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).dividerColor,
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
