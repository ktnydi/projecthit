import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/screens/auth/auth_page.dart';
import 'package:projecthit/screens/email_password/email_password_model.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:provider/provider.dart';

class EmailPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _passwordKey = GlobalKey<FormFieldState<String>>();

  Future<void> _updateEmail(
    BuildContext context,
  ) async {
    final emailPasswordModel = context.read<EmailPasswordModel>();
    final myAppModel = context.read<MyAppModel>();
    final currentEmail = myAppModel.currentUser.email;
    final email = _emailKey.currentState.value;
    final password = _passwordKey.currentState.value;

    if (email == currentEmail) return;

    if (!_formKey.currentState.validate()) {
      return;
    }

    try {
      FocusScope.of(context).unfocus();

      emailPasswordModel.beginLoading();
      await emailPasswordModel.updateEmail(email: email, password: password);
      emailPasswordModel.endLoading();

      // 不正なメールアドレスでないことをログインすることで確認する。
      await emailPasswordModel.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Auth(),
        ),
        (route) => false,
      );
      await myAppModel.fetchCurrentUser();
    } catch (e) {
      emailPasswordModel.endLoading();
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

  Future<void> _linkWithEmailAndPassword(
    BuildContext context,
  ) async {
    final emailPasswordModel = context.read<EmailPasswordModel>();
    final myAppModel = context.read<MyAppModel>();

    try {
      if (!_formKey.currentState.validate()) {
        return;
      }

      final email = _emailKey.currentState.value;
      final password = _passwordKey.currentState.value;

      emailPasswordModel.beginLoading();
      await emailPasswordModel.signUpWithEmail(
        email: email,
        password: password,
      );
      emailPasswordModel.endLoading();

      // 不正なメールアドレスでないことをログインすることで確認する。
      await emailPasswordModel.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Auth(),
        ),
        (route) => false,
      );
      await myAppModel.fetchCurrentUser();
    } catch (e) {
      emailPasswordModel.endLoading();
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
    return ChangeNotifierProvider<EmailPasswordModel>(
      create: (_) => EmailPasswordModel(),
      builder: (context, child) {
        final emailPasswordModel = context.read<EmailPasswordModel>();
        final myAppModel = context.read<MyAppModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Email & Password'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      if (myAppModel.currentUser.isAnonymous) {
                        await _linkWithEmailAndPassword(context);
                      } else {
                        await _updateEmail(context);
                      }
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (myAppModel.currentUser.isAnonymous)
                        Text(
                          'If you sign up, you are able to continue to use same account with other devices.',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption.color,
                          ),
                        ),
                      if (myAppModel.currentUser.isAnonymous)
                        SizedBox(height: 16),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        key: _emailKey,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Enter Email';
                          }

                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        initialValue: '${myAppModel.currentUser.email ?? ''}',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'projecthit@example.com',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        key: _passwordKey,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Enter Password';
                          }

                          if (!myAppModel.currentUser.isAnonymous) return null;

                          if (value.length < 6) {
                            return 'Password is too short';
                          }

                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: context.select(
                          (EmailPasswordModel model) => model.isObscure,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: context.select(
                              (EmailPasswordModel model) => model.isObscure,
                            )
                                ? Icon(Icons.remove_red_eye_outlined)
                                : Icon(Icons.remove_red_eye),
                            onPressed: () {
                              emailPasswordModel.isObscure =
                                  !emailPasswordModel.isObscure;
                              emailPasswordModel.reload();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Text(
                                'Don\'t receive verify email?',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              onTap: () {
                                // TODO: 確認メール再送信
                              },
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              onTap: () {
                                // TODO: パスワード再設定
                              },
                            ),
                            SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: 利用規約を表示
                                      },
                                  ),
                                  TextSpan(
                                    text: '｜',
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: プライバシーポリシーを表示
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.select((EmailPasswordModel model) => model.isLoading)
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
