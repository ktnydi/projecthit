import 'package:flutter/material.dart';
import 'package:projecthit/screens/accept_invitation/accept_invitation_model.dart';
import 'package:provider/provider.dart';

class AcceptInvitation extends StatelessWidget {
  final Uri deepLink;

  AcceptInvitation({@required this.deepLink});

  Future<void> _addProject(BuildContext context) async {
    final acceptInvitationModel = context.read<AcceptInvitationModel>();

    try {
      acceptInvitationModel.beginLoading();
      await acceptInvitationModel.addProject(deepLink);
      acceptInvitationModel.endLoading();

      Navigator.pop(context);
    } catch (e) {
      acceptInvitationModel.endLoading();
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
    return ChangeNotifierProvider<AcceptInvitationModel>(
      create: (_) => AcceptInvitationModel(),
      builder: (context, child) {
        return Stack(
          children: [
            Scaffold(
              body: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You are invited Project🎉',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'To join the project, please tap bellow button.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(height: 32),
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                            child: Text('Join the project'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 44),
                            ),
                            onPressed: () async {
                              await _addProject(context);
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        child: Text('No, Thanks'),
                        style: TextButton.styleFrom(
                          minimumSize: Size(200, 44),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.select((AcceptInvitationModel model) => model.isLoading)
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
