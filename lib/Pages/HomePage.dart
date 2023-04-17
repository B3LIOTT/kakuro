import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:animations/animations.dart';

import 'Menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color _btnColor = const Color(0xFF61524D);
  final Color _bgColor = const Color(0xFFFFDFC8);
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
      closedColor: _btnColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      transitionType: transitionType,
      transitionDuration: const Duration(milliseconds: 800),
        openBuilder: (BuildContext context, _) => const Menu(),
        closedBuilder: (context, VoidCallback openContainer) => Container(
      height: MediaQuery.of(context).size.width / 5,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: _btnColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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

  Widget AnButton(String text, bool isSlelected) {
    return AnimatedButton(
      width: 200,
      text: text,
      selectedTextColor: Colors.black,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      isSelected: isSlelected,
      backgroundColor: _btnColor,
      selectedBackgroundColor: _bgColor,
      borderRadius: 15,
      textStyle: const TextStyle(
          fontSize: 15,
          letterSpacing: 5,
          color: Colors.white,
          fontWeight: FontWeight.w300),
      onPress: () async {
        setState(() {
          isSlelected = !isSlelected;
        });
        await Future.delayed(const Duration(milliseconds: 2000));
        setState(() {
          isSlelected = !isSlelected;
        });
      },
    );
  }

  Widget PartyButtons() {
    return Expanded(
        child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 50,
          width: 200,
          child: AnimatedButton(
            width: 200,
            text: "NOUVELLE SOLO",
            selectedTextColor: Colors.black,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected1,
            backgroundColor: _btnColor,
            selectedBackgroundColor: _bgColor,
            borderRadius: 15,
            textStyle: const TextStyle(
                fontSize: 15,
                letterSpacing: 5,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            onPress: () async {
              setState(() {
                _isSlelected1 = !_isSlelected1;
              });
              await Future.delayed(const Duration(milliseconds: 2000));
              setState(() {
                _isSlelected1 = !_isSlelected1;
              });
            },
          ),
        ),
        SizedBox(
          height: 50,
          width: 150,
          child: AnimatedButton(
            width: 200,
            text: "CREER",
            selectedTextColor: Colors.black,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected2,
            backgroundColor: _btnColor,
            selectedBackgroundColor: _bgColor,
            borderRadius: 15,
            textStyle: const TextStyle(
                fontSize: 15,
                letterSpacing: 5,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            onPress: () async {
              setState(() {
                _isSlelected2 = !_isSlelected2;
              });
              await Future.delayed(const Duration(milliseconds: 2000));
              setState(() {
                _isSlelected2 = !_isSlelected2;
              });
            },
          ),
        ),
        SizedBox(
          height: 50,
          width: 150,
          child: AnimatedButton(
            width: 200,
            text: "REJOINDRE",
            selectedTextColor: Colors.black,
            transitionType: TransitionType.LEFT_TO_RIGHT,
            isSelected: _isSlelected3,
            backgroundColor: _btnColor,
            selectedBackgroundColor: _bgColor,
            borderRadius: 15,
            textStyle: const TextStyle(
                fontSize: 15,
                letterSpacing: 5,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            onPress: () async {
              setState(() {
                _isSlelected3 = !_isSlelected3;
              });
              await Future.delayed(const Duration(milliseconds: 2000));
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
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
                  color: Colors.black45,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                ),
                PartyButtons(),
              ])),
    );
  }
}
