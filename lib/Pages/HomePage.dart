import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:animations/animations.dart';
import 'package:kakuro/Pages/StartPage.dart';
import 'package:kakuro/main.dart';
import 'Menu.dart';
import 'PaletteSettings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<bool> _isSlelected;
  final transitionType = ContainerTransitionType.fadeThrough;
  late Alignment _menuAlignment;
  int _count = 0;
  StreamController<bool> _clickController = StreamController();
  StreamController<bool> _clickController1 = StreamController();

  @override
  void initState() {
    super.initState();
    _isSlelected = [false, false, false];
    _menuAlignment = Alignment.centerRight;
    _clickController.add(false);
    _clickController1.add(false);
  }

  void openPage(String page) async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).push(_startPageRoute(page));
    _clickController.add(false);
  }

  Widget bouton(String text, int i, snapshot) {
        return SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width / 2,
          child: AnimatedButton(
            height: 60,
            width: MediaQuery.of(context).size.width / 2,
            text: text,
            selectedTextColor: MyApp.btnColor,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected[i],
            backgroundColor: MyApp.btnColor,
            selectedBackgroundColor: MyApp.bgColor,
            borderRadius: 15,
            borderWidth: 2,
            borderColor: MyApp.btnColor,
            textStyle: TextStyle(
                fontSize: 36 * MediaQuery.of(context).size.height / 1000,
                letterSpacing: 1,
                color: MyApp.bgColor,
                fontWeight: FontWeight.w400),
            onPress:  snapshot.hasData && snapshot.data == false ? () async {
              _clickController.add(true);
              setState(() {
                _isSlelected[i] = !_isSlelected[i];
              });
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).push(_startPageRoute(text));
              _clickController.add(false);
              setState(() {
                _isSlelected[i] = !_isSlelected[i];
              });
            } : null,
          )
        );
  }

  @override
  Widget TopMenu() {
    return OpenContainer(
      closedElevation: 0,
      closedColor: MyApp.bgColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      transitionType: transitionType,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (BuildContext context, _) => const PaletteSettings(),
      closedBuilder: (context, VoidCallback openContainer) => Container(
        height: MediaQuery.of(context).size.width / 6,
        width: MediaQuery.of(context).size.width / 2,
        decoration: const BoxDecoration(
          color: MyApp.bgBtn,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: StreamBuilder(
          stream: _clickController1.stream,
          builder: (context, snapshot) {
            return ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: MyApp.btnColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.leaderboard,
                      color : Colors.white,
                    ),
                    onPressed: snapshot.hasData && snapshot.data == false ? () async {
                      _clickController1.add(true);
                      await Future.delayed(const Duration(milliseconds: 400));
                      _clickController1.add(false);
                    } : null,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: MyApp.btnColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const ImageIcon(
                      AssetImage('lib/assets/images/info.png'),
                      color : Colors.white,
                    ),
                    onPressed: snapshot.hasData && snapshot.data == false ? () async {
                      _clickController1.add(true);
                      setState(() {
                        _menuAlignment = Alignment.center;
                      });
                      await Future.delayed(const Duration(milliseconds: 200));
                      _clickController1.add(false);
                      setState(() {
                        _menuAlignment = Alignment.centerRight;
                      });
                    } : null,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: MyApp.btnColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const ImageIcon(
                      AssetImage('lib/assets/images/settings.png'),
                      color : Colors.white,
                    ),
                    onPressed: snapshot.hasData && snapshot.data == false ? () async {
                      _clickController1.add(true);
                      setState(() {
                        _menuAlignment = Alignment.center;
                      });
                      await Future.delayed(const Duration(milliseconds: 200));
                      openContainer();
                      await Future.delayed(const Duration(milliseconds: 200));
                      _clickController1.add(false);
                      setState(() {
                        _menuAlignment = Alignment.centerRight;
                      });
                    } : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget PartyButtons() {
    return Expanded(
        child: StreamBuilder<bool>(
          stream: _clickController.stream,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bouton("SOLO", 0, snapshot),
                bouton("CREER", 1, snapshot),
                bouton("REJOINDRE", 2, snapshot),
              ],
            );
          }
        )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyApp.bgColor,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                height: MediaQuery.of(context).size.height / 5,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10, right: 20),
                alignment: Alignment.topRight,
                child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 200),
                  alignment: _menuAlignment,
                  child: TopMenu(),
                )),
            Container(
              color: MyApp.bgColor,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 2.25,
              child: !(_count == 10)
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _count++;
                        });
                      },
                      child: Image.asset("lib/assets/images/logo_brown.png",
                          height: MediaQuery.of(context).size.height / 3.3))
                  : Container(
                      height: MediaQuery.of(context).size.height / 3.3,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                          child: Image.asset("lib/assets/images/easterEgg.png",
                              fit: BoxFit.cover)),
                    ),
            ),
            PartyButtons(),
          ])),
    );
  }

  Route _startPageRoute(String source) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StartPage(source),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
