import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Objects/UserPreferences.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
      return const Scaffold(
        backgroundColor: UserPreferences.bgColor,
        body: Center(
          child: Text("fesses"),
        )
      );
  }
}