import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/repository/user_repository.dart';

class MyAppModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  User currentUser;
  AppUser currentAppUser;
  StreamSubscription<User> userSubscription;
  StreamSubscription<AppUser> appUserSubscription;

  MyAppModel() {
    currentUser = _userRepository.currentUser;

    userSubscription = _userRepository.authListener().listen(
      (user) {
        currentUser = user;

        if (currentUser != null) {
          appUserSubscription =
              _userRepository.fetchUser(currentUser.uid).listen(
            (appUser) {
              currentAppUser = appUser;
            },
          );
        }

        notifyListeners();
      },
    );
  }

  Future<void> fetchCurrentUser() async {
    currentUser = _userRepository.currentUser;
    notifyListeners();
  }

  @override
  void dispose() {
    userSubscription.cancel();
    appUserSubscription.cancel();
    super.dispose();
  }
}
