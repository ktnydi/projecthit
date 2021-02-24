import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/screens/project_list/project_list_page.dart';
import 'package:projecthit/screens/sign_in/sign_in_model.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInModel>(
      create: (_) => SignInModel(),
      builder: (context, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Welcome back!'),
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
                          onChanged: (value) {
                            context.read<SignInModel>().email = value;
                          },
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
                          onChanged: (value) {
                            context.read<SignInModel>().password = value;
                          },
                        ),
                        SizedBox(height: 32),
                        Center(
                          child: ElevatedButton(
                            child: Text('Sign in'),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              minimumSize: Size(200, 44),
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) return;

                              FocusScope.of(context).unfocus();

                              // TODO: サインインする
                              final signInModel = context.read<SignInModel>();
                              try {
                                signInModel.beginLoading();
                                await signInModel.signInWithEmail();
                                signInModel.endLoading();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectList(),
                                    ),
                                    (_) => false);
                              } catch (e) {
                                signInModel.endLoading();
                              }
                            },
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
