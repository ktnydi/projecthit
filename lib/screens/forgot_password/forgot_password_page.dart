import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/class/firebase_error.dart';
import 'package:projecthit/screens/forgot_password/forgot_password_model.dart';
import 'package:projecthit/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final _emailKey = GlobalKey<FormFieldState<String>>();

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    if (!_emailKey.currentState.validate()) return;

    final forgotPasswordModel = context.read<ForgotPasswordModel>();

    try {
      final email = _emailKey.currentState.value;

      forgotPasswordModel.beginLoading();
      await forgotPasswordModel.sendPasswordResetEmail(email);
      forgotPasswordModel.endLoading();

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      forgotPasswordModel.endLoading();
      final message = FirebaseError.messageFromAuth(context, e);
      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            contentText: message,
          );
        },
      );
    } catch (e) {
      forgotPasswordModel.endLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordModel>(
      create: (_) => ForgotPasswordModel(),
      builder: (context, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).forgotPassword),
                actions: [
                  IconButton(
                    icon: Icon(Icons.send_outlined),
                    onPressed: () async {
                      await _sendPasswordResetEmail(context);
                    },
                  ),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).sendEmailDescription,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _emailKey,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return AppLocalizations.of(context).presentError(
                            AppLocalizations.of(context).emailFieldLabel,
                          );
                        }

                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'projecthit@example.com',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            context.select((ForgotPasswordModel model) => model.isLoading)
                ? Container(
                    color: Colors.white.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
