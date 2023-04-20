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

  @override
  void initState() {
    _whatsSelected = [true, false, false, false, false, false, false, false];
    super.initState();
  }

  Color getColors(String color) {
    switch (color) {
      case "default":
        return const Color(0xFF61524D);
      case "red":
        return const Color(0xFFB64549);
      case "orange":
        return const Color(0xFFC6753B);
      case "yellow":
        return const Color(0xFFE3BE3B);
      case "green":
        return const Color(0xFF5ECC69);
      case "blue":
        return const Color(0xFF47AAD4);
      case "purple":
        return const Color(0xFF9B5ED9);
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
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: UserPreferences.bgBtn,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
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
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.black,
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
              image: const AssetImage("lib/assets/images/logo_brown.png"),
              height: MediaQuery.of(context).size.height / 3.3),
        ),
        palette()
      ])),
    );
    throw UnimplementedError();
  }
}
