import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;
  static Color btnColor = Color(0xFF61524D);
  static Color bgBtn = Color(0xFFF7D0B4);
  static Color bgColor = Color(0xFFFFE6E1);

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setTheme(String color){
    _prefs!.setString('theme', color);
    switch (color){
      case 'default' :
        btnColor = const Color(0xFF61524D);
        bgBtn = const Color(0xFFF7D0B4);
        bgColor = const Color(0xFFFFE6E1);

    }
  }

  static void getTheme(){
    _prefs!.getString('theme');
  }

}