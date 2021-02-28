import 'package:flutter/material.dart';

class InviteMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite member'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'If you share inviting link, the user received inviting link can join the project.',
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Share link'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 44),
              ),
              onPressed: () {
                // TODO: 招待リンクをシェア
              },
            ),
          ],
        ),
      ),
    );
  }
}
