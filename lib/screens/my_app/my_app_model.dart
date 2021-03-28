import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/repository/user_repository.dart';
import 'package:projecthit/repository/user_token_repository.dart';

class MyAppModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  final _userTokenRepository = UserTokenRepository();
  final _messaging = FirebaseMessaging.instance;
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
              notifyListeners();
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

  Future<void> initCloudMessaging() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();

    // documentIdにトークンを指定しているので既に作成済みだとエラーが出る。
    try {
      await _userTokenRepository.add(token);
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    userSubscription.cancel();
    appUserSubscription.cancel();
    super.dispose();
  }
}
