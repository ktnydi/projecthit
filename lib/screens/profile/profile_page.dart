import 'package:flutter/material.dart';
import 'package:projecthit/screens/profile/profile_model.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _aboutKey = GlobalKey<FormFieldState<String>>();
  final name = 'Yudai Kitano';
  final about = '';

  Future<void> _updateName(
    BuildContext context,
    ProfileModel profileModel,
  ) async {
    if (!_nameKey.currentState.validate()) return;

    FocusScope.of(context).unfocus();

    final newName = _nameKey.currentState.value;

    if (name == newName) return;

    try {
      profileModel.beginLoading();
      await profileModel.updateName(newName);
      profileModel.endLoading();
    } catch (e) {
      profileModel.endLoading();
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

  Future<void> _updateAbout(
    BuildContext context,
    ProfileModel profileModel,
  ) async {
    if (!_aboutKey.currentState.validate()) return;

    FocusScope.of(context).unfocus();

    final newAbout = _aboutKey.currentState.value;

    if (newAbout == about) return;

    try {
      profileModel.beginLoading();
      await profileModel.updateAbout(newAbout);
      profileModel.endLoading();
    } catch (e) {
      profileModel.endLoading();
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
    return ChangeNotifierProvider<ProfileModel>(
      create: (_) => ProfileModel(),
      builder: (context, child) {
        final profileModel = context.read<ProfileModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      // TODO: サインアウトする
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.face_outlined,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: Icon(
                                Icons.photo_camera_outlined,
                                size: 20,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(40, 40),
                              ),
                              onPressed: () {
                                // TODO: アイコン変更
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          return TextFormField(
                            key: _nameKey,
                            initialValue: name,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Enter Name';
                              }

                              if (value.length > 50) {
                                return 'Name is too long';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (value) async {
                              await _updateName(
                                context,
                                profileModel,
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        key: _aboutKey,
                        initialValue: about,
                        validator: (value) {
                          if (1 <= value.length && value.length < 6) {
                            return 'About is too short';
                          }

                          if (value.length > 170) {
                            return 'About is too long';
                          }

                          return null;
                        },
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Introduce yourself to member',
                        ),
                        onFieldSubmitted: (value) async {
                          await _updateAbout(
                            context,
                            profileModel,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.select((ProfileModel model) => model.isLoading)
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
