import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InviteTaskMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              'Invite task member',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 4),
            Text(
              'Select members to invite',
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Icon(Icons.face_outlined),
                    ),
                    onTap: () {
                      // TODO: メンバー選択
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemCount: 3,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                child: Text('Invite'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 44),
                ),
                onPressed: () {
                  // TODO: タスクメンバーを招待
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
