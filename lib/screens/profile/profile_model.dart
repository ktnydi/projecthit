import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  final name = TextEditingController();
  final about = TextEditingController();
  bool isEditingName = false;
  bool isEditingAbout = false;
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void reload() {
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

  @override
  void dispose() {
    name.dispose();
    about.dispose();
    super.dispose();
  }
}
