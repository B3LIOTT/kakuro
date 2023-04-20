import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setTheme(String color){
    _prefs!.setString('theme', color);
  }

  static void getTheme(){
    _prefs!.getString('theme');
  }
}