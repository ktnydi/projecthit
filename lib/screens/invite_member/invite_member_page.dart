import 'package:flutter/material.dart';

class InviteMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Invite project member',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 4),
            Text(
              'Sharing invitation link to others, these users can join this project.',
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
              ),
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
