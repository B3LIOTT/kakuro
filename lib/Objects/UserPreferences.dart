import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;
  static const Color btnColor = Color(0xFF61524D);
  static const Color bgBtn = Color(0xFFF7D0B4);
  static const Color bgColor = Color(0xFFFFE6E1);

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