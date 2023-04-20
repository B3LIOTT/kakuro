import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:animations/animations.dart';
import 'package:kakuro/Pages/StartPage.dart';
import 'package:kakuro/main.dart';
import 'Menu.dart';

class PaletteSettings extends StatefulWidget {
  const PaletteSettings({super.key});

  @override
  _PaletteSettingsState createState() => _PaletteSettingsState();
}

class _PaletteSettingsState extends State<PaletteSettings>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palette Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '0',
              style: TextStyle(fontSize: 36),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
        backgroundColor: MyApp.btnColor,
      ),
    );
    throw UnimplementedError();
  }


}