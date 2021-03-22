import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/repository/user_repository.dart';

class ProfileModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  bool isLoading = false;
  File profileImageFile;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateAppUser(AppUser appUser) async {
    await _userRepository.updateAppUser(appUser: appUser);
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }

  Future<void> profileImagePicker({ImageSource source}) async {
    final pickedFile = await _imagePicker(source: source);

    if (pickedFile == null) return;

    profileImageFile = await _imageCropper(sourcePath: pickedFile.path);
    notifyListeners();
  }

  Future<PickedFile> _imagePicker({ImageSource source}) async {
    final _picker = ImagePicker();
    return await _picker.getImage(source: source);
  }

  Future<File> _imageCropper({String sourcePath}) async {
    return await ImageCropper.cropImage(
      sourcePath: sourcePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      compressQuality: 90, // 画像圧縮の品質
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
  }
}
