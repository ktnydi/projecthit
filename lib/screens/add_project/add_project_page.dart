import 'package:flutter/material.dart';
import 'package:projecthit/screens/add_project/add_project_model.dart';
import 'package:provider/provider.dart';

class AddProject extends StatelessWidget {
  final _nameKey = GlobalKey<FormFieldState<String>>();

  Future<void> _addProject(BuildContext context) async {
    if (!_nameKey.currentState.validate()) return;

    FocusScope.of(context).unfocus();

    final addProjectModel = context.read<AddProjectModel>();
    final name = _nameKey.currentState.value;

    try {
      addProjectModel.beginLoading();
      await addProjectModel.addProject(name: name);
      addProjectModel.endLoading();
      Navigator.pop(context);
    } catch (e) {
      addProjectModel.endLoading();
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
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddProjectModel>(
      create: (_) => AddProjectModel(),
      builder: (context, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      await _addProject(context);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Name',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      key: _nameKey,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter project name';
                        }

                        if (value.length > 50) {
                          return 'Project name is too long';
                        }

                        return null;
                      },
                      autofocus: true,
                      maxLength: 50,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            context.select((AddProjectModel model) => model.isLoading)
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
