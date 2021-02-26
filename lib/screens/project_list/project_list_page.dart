import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:projecthit/screens/add_project/add_project_page.dart';
import 'package:projecthit/screens/task_list/task_list_page.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('ProjectHit'),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.notifications_outlined),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            onPressed: () {
              // TODO: 通知画面を表示
            },
          ),
          IconButton(
            icon: Icon(OMIcons.settings),
            onPressed: () {
              // TODO: 設定画面を表示
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              title: Text(
                'Project Name',
              ),
              subtitle: Text('3 Members'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskList(),
                  ),
                );
              },
            ),
          );
        },
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddProject(),
            ),
          );
        },
      ),
    );
  }
}
