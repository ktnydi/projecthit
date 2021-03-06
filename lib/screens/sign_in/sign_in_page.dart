import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/project_list/project_list_page.dart';
import 'package:projecthit/screens/sign_in/sign_in_model.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _passwordKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInModel>(
      create: (_) => SignInModel(),
      builder: (context, child) {
        final signInModel = context.read<SignInModel>();
        final myAppModel = context.read<MyAppModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Welcome back!'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.login_outlined),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;

                      FocusScope.of(context).unfocus();

                      final email = _emailKey.currentState.value;
                      final password = _passwordKey.currentState.value;

                      try {
                        signInModel.beginLoading();
                        await signInModel.signInWithEmail(
                          email: email,
                          password: password,
                        );
                        await myAppModel.fetchCurrentUser();
                        signInModel.endLoading();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectList(),
                          ),
                          (_) => false,
                        );
                      } catch (e) {
                        signInModel.endLoading();
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
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              return 'Enter email';
                            }

                            if (!value.contains('@')) {
                              return 'Don\'t match mail address format';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
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
                              return 'Enter password';
                            }

                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 32),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
            ),
            context.select((SignInModel model) => model.isLoading)
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
