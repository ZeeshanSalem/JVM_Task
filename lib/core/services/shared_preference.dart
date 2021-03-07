import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider{
  static final SharedPreferencesProvider _singleton =
  SharedPreferencesProvider._internal();

  factory SharedPreferencesProvider() {
    return _singleton;
  }

  SharedPreferencesProvider._internal();

  saveFingerLoginStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFingerLogin', value);
  }

  Future<bool> getFingerLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isFingerLogin") ?? false;
  }
}