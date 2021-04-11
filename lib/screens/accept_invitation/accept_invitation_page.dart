import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/repository/user_project_repository.dart';
import 'package:projecthit/screens/accept_invitation/accept_invitation_model.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/welcome/welcome_page.dart';
import 'package:projecthit/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

class AcceptInvitation extends StatelessWidget {
  final Uri deepLink;

  AcceptInvitation({@required this.deepLink});

  Future<void> _signInAndAddProject(BuildContext context) async {
    final acceptInvitationModel = context.read<AcceptInvitationModel>();
    final appUser = context.read<MyAppModel>().currentAppUser;

    try {
      acceptInvitationModel.beginLoading();

      await acceptInvitationModel.signInWithAnonymous();
      await acceptInvitationModel.addProject(appUser, deepLink);

      acceptInvitationModel.endLoading();

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome(),
        ),
      );
    } catch (e) {
      acceptInvitationModel.endLoading();
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

  Future<void> _addProject(BuildContext context) async {
    final acceptInvitationModel = context.read<AcceptInvitationModel>();
    final appUser = context.read<MyAppModel>().currentAppUser;

    try {
      acceptInvitationModel.beginLoading();
      await acceptInvitationModel.addProject(appUser, deepLink);
      acceptInvitationModel.endLoading();

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome(),
        ),
      );
    } catch (e) {
      acceptInvitationModel.endLoading();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AcceptInvitationModel>(
      create: (_) => AcceptInvitationModel(
        userProjectRepository: context.read<UserProjectRepository>(),
      ),
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
                        AppLocalizations.of(context).acceptInvitation,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        AppLocalizations.of(context)
                            .acceptInvitationDescription,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(height: 32),
                      Builder(
                        builder: (context) {
                          final currentUser = context.select(
                            (MyAppModel model) => model.currentUser,
                          );

                          return ElevatedButton(
                            child: Text(
                              AppLocalizations.of(context).acceptButton,
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 44),
                            ),
                            onPressed: () async {
                              if (currentUser == null) {
                                return await _signInAndAddProject(context);
                              }

                              await _addProject(context);
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        child: Text(
                          AppLocalizations.of(context).acceptCancelButton,
                        ),
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
