import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String contentText;

  ErrorDialog({this.contentText}) : assert(contentText != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Oops!'),
      content: Text(contentText),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
