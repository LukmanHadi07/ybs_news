class Env {
  Env._();

  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:3001');

  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static bool get isDev => flavor.toLowerCase() == 'dev';
}
