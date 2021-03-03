import 'package:flutter/material.dart';

class InquiryModel extends ChangeNotifier {
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

  Future<void> addInquiry({
    @required String email,
    @required String body,
  }) async {
    // TODO: お問い合わせ内容を保存
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
