import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;
  static Color btnColor = const Color(0xFF61524D);
  static Color bgBtn = const Color(0xFFF7D0B4);
  static Color bgColor = const Color(0xFFFFE6E1);

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
        break;
      case 'red' :
        btnColor = const Color(0xFFB64549);
        bgBtn = const Color(0xFFE6B0B0);
        bgColor = const Color(0xFFFFE6E1);
        break;
    }
  }

  static void getTheme(){
    _prefs!.getString('theme');
  }

}