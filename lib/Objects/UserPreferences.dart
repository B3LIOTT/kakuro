import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
}