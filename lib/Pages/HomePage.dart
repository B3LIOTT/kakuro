import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:animations/animations.dart';
import 'package:kakuro/Pages/StartPage.dart';
import 'package:kakuro/main.dart';
import 'Menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isSlelected1;
  late bool _isSlelected2;
  late bool _isSlelected3;
  final transitionType = ContainerTransitionType.fadeThrough;
  late Alignment _menuAlignment;

  @override
  void initState() {
    super.initState();
    _isSlelected1 = false;
    _isSlelected2 = false;
    _isSlelected3 = false;
    _menuAlignment = Alignment.centerRight;
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
        openBuilder: (BuildContext context, _) => const Menu(),
        closedBuilder: (context, VoidCallback openContainer) => Container(
      height: MediaQuery.of(context).size.width / 6,
      width: MediaQuery.of(context).size.width / 2,
      decoration: const BoxDecoration(
        color: MyApp.bgBtn,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () async {
                setState(() {
                  _menuAlignment = Alignment.center;
                });
                await Future.delayed(const Duration(milliseconds: 400));
                setState(() {
                  _menuAlignment = Alignment.centerRight;
                });
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                _menuAlignment = Alignment.center;
              });
              await Future.delayed(const Duration(milliseconds: 400));
              setState(() {
                _menuAlignment = Alignment.centerRight;
              });
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () async {
                setState(() {
                _menuAlignment = Alignment.center;
                });
                await Future.delayed(const Duration(milliseconds: 400));
                openContainer();
                await Future.delayed(const Duration(milliseconds: 100));
                setState(() {
                _menuAlignment = Alignment.centerRight;
                });
              },
            icon: const Icon(Icons.home),
          )
        ],
      ),
     ),
    );
  }

  Widget PartyButtons() {
    return Expanded(
        child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width / 2,
          child: AnimatedButton(
            height: 60,
            width: MediaQuery.of(context).size.width / 2,
            text: "SOLO",
            selectedTextColor: MyApp.btnColor,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected1,
            backgroundColor: MyApp.btnColor,
            selectedBackgroundColor: MyApp.bgColor,
            borderRadius: 15,
            borderWidth: 2,
            borderColor: MyApp.btnColor,
            textStyle: const TextStyle(
                fontSize: 30,
                letterSpacing: 1,
                color: MyApp.bgColor,
                fontWeight: FontWeight.w400),
            onPress: () async {
              setState(() {
                _isSlelected1 = !_isSlelected1;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).push(_startPageRoute("SOLO"));
              setState(() {
                _isSlelected1 = !_isSlelected1;
              });
            },
          ),
        ),
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width / 2,
          child: AnimatedButton(
            height: 60,
            width: MediaQuery.of(context).size.width / 2,
            text: "CREER",
            selectedTextColor: MyApp.btnColor,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected2,
            backgroundColor: MyApp.btnColor,
            selectedBackgroundColor: MyApp.bgColor,
            borderRadius: 15,
            borderWidth: 2,
            borderColor: MyApp.btnColor,
            textStyle: const TextStyle(
                fontSize: 30,
                letterSpacing: 1,
                color: MyApp.bgColor,
                fontWeight: FontWeight.w400),
            onPress: () async {
              setState(() {
                _isSlelected2 = !_isSlelected2;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).push(_startPageRoute("CREER"));
              setState(() {
                _isSlelected2 = !_isSlelected2;
              });
            },
          ),
        ),
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width / 2,
          child: AnimatedButton(
            height: 60,
            width: MediaQuery.of(context).size.width / 2,
            text: "REJOINDRE",
            selectedTextColor: MyApp.btnColor,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected3,
            backgroundColor: MyApp.btnColor,
            selectedBackgroundColor: MyApp.bgColor,
            borderRadius: 15,
            borderWidth: 2,
            borderColor: MyApp.btnColor,
            textStyle: const TextStyle(
                fontSize: 30,
                letterSpacing: 1,
                color: MyApp.bgColor,
                fontWeight: FontWeight.w400),
            onPress: () async {
              setState(() {
                _isSlelected3 = !_isSlelected3;
              });
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).push(_startPageRoute("REJOINDRE"));
              setState(() {
                _isSlelected3 = !_isSlelected3;
              });
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10),
          height: MediaQuery.of(context).padding.bottom + 15,
          child: const Text("Made by 3 INSA Hauts De France students",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300
              )
          )
        )
      ],
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10, right: 20),
                  alignment: Alignment.topRight,
                  child: AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 400),
                    alignment: _menuAlignment,
                    child: TopMenu(),
                  )
                ),
                Container(
                  color: MyApp.bgColor,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
                PartyButtons(),
              ])),
    );
  }

  Route _startPageRoute(String source) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => StartPage(source),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}
