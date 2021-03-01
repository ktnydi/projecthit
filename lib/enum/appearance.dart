enum Appearance {
  light,
  dark,
}

extension ExAppearance on Appearance {
  String get name {
    switch (this) {
      case Appearance.light:
        return 'Light';
      case Appearance.dark:
        return 'Dark';
    }
    return 'Light';
  }
}
