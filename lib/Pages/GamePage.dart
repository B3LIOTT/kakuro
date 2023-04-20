import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Objects/UserPreferences.dart';

class GamePage extends StatefulWidget {
  late final String _diff;
  late final String _size;
  GamePage(this._diff, this._size, {super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: UserPreferences.bgColor,
        body: Center(
          child: Text("Difficulté: ${widget._diff} | Taille: ${widget._size}"),
        )
      );
  }
}