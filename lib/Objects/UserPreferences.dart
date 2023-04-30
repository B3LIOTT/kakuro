import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import 'Carre.dart';

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
        bgColor = const Color(0xFFFFEEE1);
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
        btnColor = const Color(0xFFFFC700);
        bgBtn = const Color(0xFFFFF1B0);
        bgColor = const Color(0xFFFFF7DD);
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
  
  static void setGame(List<List<Carre>> board) {
    List<String> jsonGame = [];
    for (final row in board) {
      final jsonRow = jsonEncode(row.map((c) => c.toJson()).toList());
      jsonGame.add(jsonRow);
    }
    _prefs!.setStringList('game', jsonGame);
    print('Game saved');
  }

  static List<List<Carre>> getGame() {
    List<String> jsonGame = _prefs!.getStringList('game') ?? [];
    List<List<Carre>> game = [];
    for (final json in jsonGame) {
      final List<Carre> row = [];

      for (final carreJson in jsonDecode(json)) {
        final carre = Carre.fromJson(carreJson);
        row.add(carre);
      }
      game.add(row);
    }
    return game;
  }

  static void clearGame() {
    _prefs!.remove('game');
    print('Game cleared');
  }

  static int get getSize {
    return _prefs!.getInt('size') ?? 8;
  }

  static void setSize(int size) {
    _prefs!.setInt('size', size);
  }

  static double get getDensity {
    return _prefs!.getDouble('diff') ?? 8;
  }

  static void setDensity(double diff) {
    _prefs!.setDouble('diff', diff);
  }

  static List<int> get getTimer {
    return _prefs!.getString('timer')?.split(':').map((e) => int.parse(e)).toList() ?? [0, 0, 0];
  }

  static void setTimer(List<int> timer) {
    _prefs!.setString('timer', timer.map((e) => e.toString()).join(':'));
  }
}