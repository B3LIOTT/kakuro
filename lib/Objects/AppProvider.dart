import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {

  void updateTheme() {
    notifyListeners();
  }

}