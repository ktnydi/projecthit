import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class MyAppModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  User currentUser;

  MyAppModel() {
    currentUser = _userRepository.currentUser;
  }

  Future<void> fetchCurrentUser() async {
    currentUser = _userRepository.currentUser;
    notifyListeners();
  }
}
