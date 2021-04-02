import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/screens/forgot_password/forgot_password_model.dart';
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
    } catch (e) {
      forgotPasswordModel.endLoading();
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
