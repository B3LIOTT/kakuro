import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'PaletteSettings.dart';

class TopMenu extends StatefulWidget {
const TopMenu({super.key});

  @override
  _TopMenuState createState() => _TopMenuState();

}

class _TopMenuState extends State<TopMenu> {
  StreamController<bool> _clickController = StreamController();
  StreamController<bool> _clickController1 = StreamController();
  final transitionType = ContainerTransitionType.fadeThrough;
  late Alignment _menuAlignment;

  @override
  void initState() {
    super.initState();
    _clickController.add(false);
    _clickController1.add(false);
    _menuAlignment = Alignment.centerRight;
  }

  Widget topMenu() {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          alignment: _menuAlignment,
          child: topMenu(),
        );
  }
}