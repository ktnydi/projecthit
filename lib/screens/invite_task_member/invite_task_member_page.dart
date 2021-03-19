import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/screens/invite_task_member/invite_task_member_model.dart';
import 'package:provider/provider.dart';

class InviteTaskMember extends StatelessWidget {
  final Project project;

  InviteTaskMember({@required this.project});

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
                      return SizedBox();
                    }

                    final projectUsers = snapshot.data;

                    final widgets = projectUsers.map(
                      (projectUser) {
                        return FutureBuilder<AppUser>(
                          future: inviteTaskMemberModel.fetchUser(projectUser),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  child: Icon(Icons.face_outlined),
                                ),
                              );
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  child: Icon(Icons.face_outlined),
                                ),
                                onTap: () {
                                  // TODO: メンバー選択
                                },
                              ),
                            );
                          },
                        );
                      },
                    ).toList();

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: widgets,
                      ),
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
                    onPressed: () {
                      // TODO: タスクメンバーを招待
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
