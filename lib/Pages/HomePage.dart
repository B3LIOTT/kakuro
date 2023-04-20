import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:animations/animations.dart';
import 'package:kakuro/Pages/StartPage.dart';
import '../Objects/UserPreferences.dart';
import 'TopMenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<bool> _isSlelected;
  final transitionType = ContainerTransitionType.fadeThrough;
  int _count = 0;
  StreamController<bool> _clickController = StreamController();
  StreamController<bool> _clickController1 = StreamController();

  @override
  void initState() {
    super.initState();
    _isSlelected = [false, false, false];
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
            selectedTextColor: UserPreferences.btnColor,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected[i],
            backgroundColor: UserPreferences.btnColor,
            selectedBackgroundColor: UserPreferences.bgColor,
            borderRadius: 15,
            borderWidth: 2,
            borderColor: UserPreferences.btnColor,
            textStyle: TextStyle(
                fontSize: 36 * MediaQuery.of(context).size.height / 1000,
                letterSpacing: 1,
                color: UserPreferences.bgColor,
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
      backgroundColor: UserPreferences.bgColor,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, right: 20, left: 20),
              child: const TopMenu(),
            ),
            Container(
              color: UserPreferences.bgColor,
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
