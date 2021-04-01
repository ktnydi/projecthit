import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/screens/auth/auth_model.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/sign_in/sign_in_page.dart';
import 'package:projecthit/screens/welcome/welcome_page.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => AuthModel(),
      builder: (context, child) {
        final myAppModel = context.read<MyAppModel>();

        return Stack(
          children: [
            Scaffold(
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: isDark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ProjectHit',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Best project management tool',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child:
                                    Text(AppLocalizations.of(context).signUp),
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.onSecondary,
                                  onPrimary:
                                      Theme.of(context).colorScheme.secondary,
                                  minimumSize: Size(200, 44),
                                ),
                                onPressed: () async {
                                  final authModel = context.read<AuthModel>();
                                  try {
                                    authModel.beginLoading();
                                    await authModel.signUpWithAnonymous();
                                    await myAppModel.fetchCurrentUser();
                                    authModel.endLoading();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Welcome(),
                                      ),
                                    );
                                  } catch (e) {
                                    authModel.endLoading();
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
                              SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context).signInMessage,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                              SizedBox(height: 16),
                              OutlinedButton(
                                child:
                                    Text(AppLocalizations.of(context).signIn),
                                style: OutlinedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.onSecondary,
                                  side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                  minimumSize: Size(200, 44),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => SignIn(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)
                                          .termsOfService,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // TODO: 利用規約を表示
                                        },
                                    ),
                                    TextSpan(text: '｜'),
                                    TextSpan(
                                      text: AppLocalizations.of(context)
                                          .privacyPolicy,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.select((AuthModel model) => model.isLoading)
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
