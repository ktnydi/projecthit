import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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
                          color: Theme.of(context).colorScheme.secondary,
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
                        child: Text('Start'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.onSecondary,
                          onPrimary: Theme.of(context).colorScheme.secondary,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          minimumSize: Size(200, 44),
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Have you already account?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      SizedBox(height: 16),
                      OutlinedButton(
                        child: Text('Sign in'),
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.onSecondary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          minimumSize: Size(200, 44),
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(height: 16),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Term',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // TODO: 利用規約を表示
                                },
                            ),
                            TextSpan(text: '｜'),
                            TextSpan(
                              text: 'Privacy',
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
    );
  }
}
