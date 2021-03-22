import 'dart:io';

import 'package:flutter/material.dart';
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

  Future<void> imagePicker({ImageSource source}) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: source);
    profileImageFile = File(pickedFile.path);
    notifyListeners();
  }
}
