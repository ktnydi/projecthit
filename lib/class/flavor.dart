class Flavor {
  String now;

  static const development = 'Development';
  static const staging = 'Staging';
  static const production = 'Production';

  Flavor.fromString(String flavor) {
    now = flavor;
  }
}
