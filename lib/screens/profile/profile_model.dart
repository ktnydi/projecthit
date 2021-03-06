import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class ProfileModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    // TODO: 名前の更新
    await Future.delayed(Duration(milliseconds: 3000));
  }

  Future<void> updateAbout(String about) async {
    // TODO: 自己紹介の更新
    await Future.delayed(Duration(milliseconds: 3000));
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
