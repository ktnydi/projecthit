import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';

class WelcomeModel extends ChangeNotifier {
  Project project;

  Future<void> fetchProject() async {
    // TODO: プロジェクト取得処理（以下は仮の実装）
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
