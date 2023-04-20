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
      case 'green' :
        btnColor = const Color(0xFF5ECC69);
        bgBtn = const Color(0xFFC4EDC8);
        bgColor = const Color(0xFFF0FFEF);
        logoPath = 'lib/assets/images/logo_green.png';
        break;
      case 'blue' :
        btnColor = const Color(0xFF2CAAF1);
        bgBtn = const Color(0xFFB3E0FF);
        bgColor = const Color(0xFFE6F7FF);
        logoPath = 'lib/assets/images/logo_blue.png';
        break;
      case 'purple' :
        btnColor = const Color(0xFF955AE0);
        bgBtn = const Color(0xFFD9C4FF);
        bgColor = const Color(0xFFF7E6FF);
        logoPath = 'lib/assets/images/logo_purple.png';
        break;
      case 'dark' :
        btnColor = const Color(0xFF393939);
        bgBtn = const Color(0xFFB3B3B3);
        bgColor = const Color(0xFFE7E7E7);
        logoPath = 'lib/assets/images/logo_round.png';
        break;
    }
    _prefs!.setString('theme', color);
  }

  static String getTheme(){
    return _prefs!.getString('theme') ?? 'default';
  }
}