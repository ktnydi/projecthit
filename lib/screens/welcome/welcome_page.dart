import 'package:flutter/material.dart';
import 'package:projecthit/screens/add_project/add_project_page.dart';
import 'package:projecthit/screens/task_list/task_list_page.dart';
import 'package:projecthit/screens/welcome/welcome_model.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WelcomeModel>(
      create: (_) => WelcomeModel(),
      builder: (context, snapshot) {
        final welcomeModel = context.read<WelcomeModel>();

        return Scaffold(
          body: FutureBuilder<void>(
            future: welcomeModel.fetchProject(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final project = context.select(
                (WelcomeModel model) => model.project,
              );

              return project != null
                  ? TaskList(project: project)
                  : AddProject();
            },
          ),
        );
      },
    );
  }
}
