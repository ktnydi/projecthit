import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/profile/profile_model.dart';
import 'package:projecthit/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _aboutKey = GlobalKey<FormFieldState<String>>();
  final _formKey = GlobalKey<FormState>();

  Future<void> _updateProfile(BuildContext context) async {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).unfocus();

    final profileModel = context.read<ProfileModel>();

    final newName = _nameKey.currentState.value;
    final newAbout = _aboutKey.currentState.value;

    final myAppModel = context.read<MyAppModel>();
    final oldName = myAppModel.currentAppUser.name;
    final oldAbout = myAppModel.currentAppUser.about;

    if (newName == oldName && newAbout == oldAbout) return;

    try {
      profileModel.beginLoading();
      final appUser = myAppModel.currentAppUser;
      appUser.name = newName;
      appUser.about = newAbout;
      await profileModel.updateAppUser(appUser);
      profileModel.endLoading();
    } catch (e) {
      profileModel.endLoading();
      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            contentText: e.toString(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileModel>(
      create: (context) {
        final currentAppUser = context.read<MyAppModel>().currentAppUser;
        return ProfileModel(currentAppUser);
      },
      builder: (context, child) {
        final myAppModel = context.read<MyAppModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).profile),
                actions: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      await _updateProfile(context);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: _ProfileImage(),
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context).userName,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Builder(
                          builder: (context) {
                            return TextFormField(
                              key: _nameKey,
                              initialValue: myAppModel.currentAppUser.name,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return AppLocalizations.of(context)
                                      .presentError(
                                    AppLocalizations.of(context).userName,
                                  );
                                }

                                if (value.length > 50) {
                                  return AppLocalizations.of(context)
                                      .maximumTextLengthError(
                                    AppLocalizations.of(context).userName,
                                  );
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context).userAbout,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        TextFormField(
                          key: _aboutKey,
                          initialValue: myAppModel.currentAppUser.about,
                          validator: (value) {
                            if (1 <= value.length && value.length < 6) {
                              return AppLocalizations.of(context)
                                  .minimumTextLengthError(
                                AppLocalizations.of(context).userAbout,
                              );
                            }

                            if (value.length > 170) {
                              return AppLocalizations.of(context)
                                  .maximumTextLengthError(
                                AppLocalizations.of(context).userAbout,
                              );
                            }

                            return null;
                          },
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context)
                                .userAboutPlaceholder,
                          ),
                        ),
                      ],
                    ),
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

class _ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileModel = context.read<ProfileModel>();

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 140,
            height: 140,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: context.select(
              (MyAppModel model) => model.currentAppUser.icon != null,
            )
                ? CachedNetworkImage(
                    imageUrl: context.select(
                      (MyAppModel model) => model.currentAppUser.icon,
                    ),
                    fit: BoxFit.cover,
                  )
                : Text(
                    'Image',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
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
          onPressed: () async {
            try {
              await profileModel.profileImagePickerAndUpload(
                source: ImageSource.gallery,
              );
            } catch (e) {
              showDialog(
                context: context,
                builder: (context) {
                  return ErrorDialog(
                    contentText: e.toString(),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
