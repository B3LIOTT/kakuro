import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  String _word = "";

  void updateKeyWord(String word) {
    _word = word;
    notifyListeners();
  }

  String get keyWord {
    return _word;
  }

}