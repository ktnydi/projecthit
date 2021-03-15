import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/repository/user_repository.dart';

class MyAppModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  User currentUser;
  AppUser currentAppUser;
  StreamSubscription<AppUser> appUserSubscription;

  MyAppModel() {
    currentUser = _userRepository.currentUser;

    if (currentUser != null) {
      appUserSubscription = _userRepository.fetchUser(currentUser.uid).listen(
        (appUser) {
          currentAppUser = appUser;
          notifyListeners();
        },
      );
    }
  }

  Future<void> fetchCurrentUser() async {
    currentUser = _userRepository.currentUser;
    notifyListeners();
  }

  @override
  void dispose() {
    appUserSubscription.cancel();
    super.dispose();
  }
}
