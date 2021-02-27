import 'package:flutter/material.dart';
import 'package:projecthit/screens/project_detail/project_detail_page.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Name',
            ),
            Text(
              '3 Members',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ProjectDetail(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    OutlinedButton(
                      child: Icon(
                        Icons.circle,
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(34, 34),
                      ),
                      onPressed: () {
                        // TODO: タスク完了処理を追加
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Task $index',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '21, Feb 2021',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Icon(Icons.face_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                // TODO: タスク設定画面を表示
              },
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: タスク作成画面を表示
        },
      ),
    );
  }
}
