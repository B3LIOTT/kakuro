import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

import '../main.dart';
import 'Menu.dart';

class StartPage extends StatefulWidget {
  late String _source;

  StartPage(this._source, {super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late bool _isSlelected;
  final transitionType = ContainerTransitionType.fadeThrough;
  late Alignment _menuAlignment;
  final TextEditingController textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSlelected = false;
    _menuAlignment = Alignment.centerRight;
  }

  List<Widget> childrenList(String source) {
    List<Widget> children = [];

    switch (source) {
      case "SOLO":
        children = [

        ];
        break;
      case "CREER":
        children = [

        ];
        break;

      case "REJOINDRE":
        children = [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 1.5,
            child: TextField(
              textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                cursorColor: Colors.black,
                style: const TextStyle(
                  fontSize: 35,
                  //fontFamily:
                ),
                controller: textFieldController,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    isDense: false,
                    fillColor: MyApp.bgColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MyApp.btnColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: MyApp.btnColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'XXXXX-YYYY',
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: 30,
                    ))),
          ),

        ];
        break;
    }
    return children;
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

  Widget midWidget(String source) {
    return Container(
        color: MyApp.bgColor,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: childrenList(source),
        ));
  }

  Widget playButton() {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width / 2,
      child: AnimatedButton(
        height: 60,
        width: MediaQuery.of(context).size.width / 2,
        text: widget._source,
        selectedTextColor: MyApp.btnColor,
        transitionType: TransitionType.LEFT_TO_RIGHT,
        isSelected: _isSlelected,
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
            _isSlelected = !_isSlelected;
          });
          await Future.delayed(const Duration(milliseconds: 500));

          setState(() {
            _isSlelected = !_isSlelected;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  duration: const Duration(milliseconds: 400),
                  alignment: _menuAlignment,
                  child: TopMenu(),
                )),
            midWidget(widget._source),
            playButton(),
            (widget._source == "REJOINDRE")? const Expanded(
                child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      "Demandez le code de la partie à celui qui l'a créé, il est de la forme : \nXXXXX-YYYY \navec X une lettre majuscule et Y un chiffre",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyApp.btnColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                )) : const Expanded(child: SizedBox()),
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
