import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/screens/invite_member/invite_member_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class InviteMember extends StatelessWidget {
  final Project project;

  InviteMember({@required this.project});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InviteMemberModel>(
      create: (_) => InviteMemberModel(),
      builder: (context, child) {
        final inviteMemberModel = context.read<InviteMemberModel>();

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SafeArea(
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
                  'Invite project member',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 4),
                Text(
                  'Sharing invitation link to others, these users can join this project.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
                SizedBox(height: 16),
                FutureBuilder(
                  future: inviteMemberModel.createDynamicLink(project),
                  builder: (context, snapshot) {
                    bool isLoading =
                        snapshot.connectionState == ConnectionState.waiting;

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Oops! ${snapshot.error}'),
                      );
                    }

                    return ElevatedButton(
                      child: !isLoading
                          ? Text('Share link')
                          : Text('Now Loading...'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 44),
                      ),
                      onPressed: !isLoading
                          ? () async {
                              Navigator.pop(context);
                              await Share.share(
                                inviteMemberModel.url.toString(),
                              );
                            }
                          : null,
                    );
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
