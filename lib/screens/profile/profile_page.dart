import 'package:flutter/material.dart';
import 'package:projecthit/screens/profile/profile_model.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  void _editName(ProfileModel profileModel) {
    // 自己紹介が編集中なら名前は編集できない
    if (profileModel.isEditingAbout) return;

    profileModel.isEditingName = true;
    profileModel.reload();
  }

  Future<void> _updateName(
    BuildContext context,
    ProfileModel profileModel,
    String newName,
  ) async {
    try {
      FocusScope.of(context).unfocus();

      if (newName.trim().isNotEmpty) {
        profileModel.beginLoading();
        await profileModel.updateName(newName);
        profileModel.endLoading();
      }

      profileModel.isEditingName = false;
      profileModel.reload();
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

  void _editAbout(ProfileModel profileModel) {
    // 名前が編集中なら自己紹介は編集できない
    if (profileModel.isEditingName) return;

    profileModel.isEditingAbout = true;
    profileModel.reload();
  }

  Future<void> _updateAbout(
    BuildContext context,
    ProfileModel profileModel,
    String newAbout,
  ) async {
    try {
      FocusScope.of(context).unfocus();

      if (newAbout.trim().isNotEmpty) {
        profileModel.beginLoading();
        await profileModel.updateAbout(newAbout);
        profileModel.endLoading();
      }

      profileModel.isEditingAbout = false;
      profileModel.reload();
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
    String name = 'Yudai Kitano';
    String about = '';

    return ChangeNotifierProvider<ProfileModel>(
      create: (_) => ProfileModel(),
      builder: (context, child) {
        final profileModel = context.read<ProfileModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
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
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: context.select(
                                    (ProfileModel model) => model.isEditingName)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'Enter Name';
                                        }

                                        if (value.length > 50) {
                                          return 'Name is too long';
                                        }

                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: profileModel.name
                                        ..text = name
                                        ..selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                            offset: name.length,
                                          ),
                                        ),
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        name = value;
                                      },
                                      onFieldSubmitted: (value) async {
                                        await _updateName(
                                          context,
                                          profileModel,
                                          value,
                                        );
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                      '$name',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                          ),
                          IconButton(
                            icon: context.select(
                              (ProfileModel model) => model.isEditingName,
                            )
                                ? Icon(Icons.done)
                                : Icon(Icons.edit_outlined),
                            visualDensity: VisualDensity.compact,
                            onPressed: () async {
                              if (!profileModel.isEditingName) {
                                return _editName(profileModel);
                              }

                              await _updateName(
                                context,
                                profileModel,
                                name,
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'About',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: context.select((ProfileModel model) =>
                                    model.isEditingAbout)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (1 <= value.length &&
                                            value.length < 6) {
                                          return 'About is too short';
                                        }

                                        if (value.length > 170) {
                                          return 'About is too long';
                                        }

                                        return null;
                                      },
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: profileModel.about
                                        ..text = about
                                        ..selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                            offset: about.length,
                                          ),
                                        ),
                                      autofocus: true,
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText:
                                            'Introduce yourself to member',
                                      ),
                                      onChanged: (value) {
                                        about = value;
                                      },
                                      onFieldSubmitted: (value) async {
                                        await _updateAbout(
                                          context,
                                          profileModel,
                                          value,
                                        );
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Text(
                                      '$about',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                          ),
                          IconButton(
                            icon: context.select((ProfileModel model) =>
                                    model.isEditingAbout)
                                ? Icon(Icons.done)
                                : Icon(Icons.edit_outlined),
                            visualDensity: VisualDensity.compact,
                            onPressed: () async {
                              if (!profileModel.isEditingAbout) {
                                return _editAbout(profileModel);
                              }

                              await _updateAbout(
                                context,
                                profileModel,
                                about,
                              );
                            },
                          ),
                        ],
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
