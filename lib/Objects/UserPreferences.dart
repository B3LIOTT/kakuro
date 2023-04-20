import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;
  static late Color btnColor;
  static late Color bgBtn;
  static late Color bgColor;
  static String logoPath = 'lib/assets/images/logo_brown.png';

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setTheme(getTheme());
  }

  static void setTheme(String color){
    switch (color){
      case 'default' :
        btnColor = const Color(0xFF61524D);
        bgBtn = const Color(0xFFF7D0B4);
        bgColor = const Color(0xFFFFE6E1);
        logoPath = 'lib/assets/images/logo_brown.png';
        break;
      case 'red' :
        btnColor = const Color(0xFFB64549);
        bgBtn = const Color(0xFFE6B0B0);
        bgColor = const Color(0xFFFFE1E1);
        logoPath = 'lib/assets/images/logo_red.png';
        break;
      case 'orange' :
        btnColor = const Color(0xFFDB7329);
        bgBtn = const Color(0xFFF7D0B4);
        bgColor = const Color(0xFFFFE7CA);
        logoPath = 'lib/assets/images/logo_orange.png';
        break;
      case 'yellow' :
        btnColor = const Color(0xFFFFD028);
        bgBtn = const Color(0xFFFFF2C3);
        bgColor = const Color(0xFFFFFCEF);
        logoPath = 'lib/assets/images/logo_yellow.png';
        break;
    }
    _prefs!.setString('theme', color);
  }

  static String getTheme(){
    return _prefs!.getString('theme') ?? 'default';
  }
}