import 'package:flutter/material.dart';
import 'package:kakuro/Objects/AppProvider.dart';
import 'package:provider/provider.dart';
import '../Objects/UserPreferences.dart';

class PaletteSettings extends StatefulWidget {
  const PaletteSettings({super.key});

  @override
  _PaletteSettingsState createState() => _PaletteSettingsState();
}

class _PaletteSettingsState extends State<PaletteSettings> {
  late List<bool> _whatsSelected;
  late List<String> themes;

  @override
  void initState() {
    themes = ["default", "red", "orange", "yellow", "green", "blue", "purple", "dark"];
    _whatsSelected = List.filled(themes.length, false);
    for (int i = 0; i < themes.length; i++) {
      if (UserPreferences.getTheme() == themes[i]) {
        _whatsSelected[i] = true;
      }
    }
    super.initState();
  }

  Color getColors(String color) {
    switch (color) {
      case "default":
        return const Color(0xFF61524D);
      case "red":
        return const Color(0xFFB64549);
      case "orange":
        return const Color(0xFFDB7329);
      case "yellow":
        return const Color(0xFFFFD028);
      case "green":
        return const Color(0xFF5ECC69);
      case "blue":
        return const Color(0xFF2CAAF1);
      case "purple":
        return const Color(0xFF955AE0);
      case "dark":
        return const Color(0xFF393939);
      default:
        return const Color(0xFF61524D);
    }
  }

  Widget colorButton(String color, bool isSelected, int position) {
    return InkWell(
      onTap: () {
        setState(() {
          UserPreferences.setTheme(color);
          _whatsSelected[position] = true;
          for (int i = 0; i < _whatsSelected.length; i++) {
            if (i != position) {
              _whatsSelected[i] = false;
            }
          }
        });
        var settings = context.read<AppProvider>();
        settings.updateTheme();
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: getColors(color),
          borderRadius: BorderRadius.circular(15),
        ),
        child: AnimatedOpacity(
          opacity: isSelected ? 1 : 0,
          duration: const Duration(milliseconds: 150),
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }

  Widget palette() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 325,
        maxHeight: 175,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: UserPreferences.bgBtn,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: <Widget>[
          colorButton("default", _whatsSelected[0], 0),
          colorButton("red", _whatsSelected[1], 1),
          colorButton("orange", _whatsSelected[2], 2),
          colorButton("yellow", _whatsSelected[3], 3),
          colorButton("green", _whatsSelected[4], 4),
          colorButton("blue", _whatsSelected[5], 5),
          colorButton("purple", _whatsSelected[6], 6),
          colorButton("dark", _whatsSelected[7], 7),
        ],
      ),
    );
  }

  Widget returnBtn() {
    return Container(
      decoration: BoxDecoration(
        color: UserPreferences.bgBtn,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: UserPreferences.btnColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences.bgColor,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top+15, left:20),
              child: returnBtn(),
            ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height/ 3.3,
          child: Image(
              image: AssetImage(UserPreferences.logoPath),
              height: MediaQuery.of(context).size.height / 3.3),
        ),
        palette(),
      ])),
    );
    throw UnimplementedError();
  }
}
