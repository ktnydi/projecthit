import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:projecthit/screens/add_project/add_project_page.dart';
import 'package:projecthit/screens/setting/setting_page.dart';
import 'package:projecthit/screens/task_list/task_list_page.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'ProjectHit',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(OMIcons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Setting(),
                ),
              );
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
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ProjectName',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '3 Members',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
