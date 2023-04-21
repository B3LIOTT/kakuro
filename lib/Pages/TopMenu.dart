import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakuro/Objects/AppProvider.dart';
import 'package:provider/provider.dart';
import '../Objects/UserPreferences.dart';
import 'PaletteSettings.dart';

class TopMenu extends StatefulWidget {
  late final String _source;
  TopMenu(this._source, {super.key});

  @override
  _TopMenuState createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  final StreamController<bool> _clickController = StreamController();
  final transitionType = ContainerTransitionType.fadeThrough;
  late Alignment _menuAlignment;
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _clickController.add(false);
    _menuAlignment = Alignment.centerRight;
    switch(widget._source) {
      case "GamePage":
        _content = 'Each puzzle consists of a blank grid with sum-clues in various places. The object is to fill all empty squares using numbers 1 to 9 so the sum of each horizontal block equals the clue on its left, and the sum of each vertical block equals the clue on its top. In addition, no number may be used in the same block more than once.';
        _title = 'RULES';
        break;
      case "StartPage":
        _content = 'The difficulty of the game is based on the number of cells to fill in the grid. The more cells to fill, the more difficult the game will be. So a small KAKURO can be more difficult than a big one with lots of black cells';
        _title = 'INFOS';
        break;
      case "HomePage":
        _content = 'A flutter app made by 3 students from the engineering school INSA Haut De France';
        _title = 'CREDITS';
        break;
    }

  }

  void showCredits() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: UserPreferences.bgColor,
        title: Text(_title, style: TextStyle(color: UserPreferences.btnColor, fontWeight: FontWeight.bold)),
        content: Text(_content, style: TextStyle(color: UserPreferences.btnColor)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('Ok', style: TextStyle(color: UserPreferences.btnColor, fontSize: 20)),
          ),
        ],
      ),);
  }

  Widget topMenu() {
    return StreamBuilder<bool>(
        stream: _clickController.stream,
        builder: (context, snapshot) {
          return OpenContainer(
            tappable: false,
            closedElevation: 0,
            closedColor: UserPreferences.bgColor,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            transitionType: transitionType,
            transitionDuration: const Duration(milliseconds: 600),
            openBuilder: (BuildContext context, _) => const PaletteSettings(),
            closedBuilder: (context, VoidCallback openContainer) => Container(
              height: MediaQuery.of(context).size.width / 6,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: UserPreferences.bgBtn,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: UserPreferences.btnColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.leaderboard,
                        color: Colors.white,
                      ),
                      onPressed: snapshot.hasData && snapshot.data == false
                          ? () async {
                              _clickController.add(true);
                              await Future.delayed(
                                  const Duration(milliseconds: 400));
                              _clickController.add(false);
                            }
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: UserPreferences.btnColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const ImageIcon(
                        AssetImage('lib/assets/images/info.png'),
                        color: Colors.white,
                      ),
                      onPressed: snapshot.hasData && snapshot.data == false
                          ? () async {
                              _clickController.add(true);
                              setState(() {
                                _menuAlignment = Alignment.center;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              showCredits();
                              setState(() {
                                _menuAlignment = Alignment.centerRight;
                              });
                              _clickController.add(false);
                            }
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: UserPreferences.btnColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const ImageIcon(
                        AssetImage('lib/assets/images/settings.png'),
                        color: Colors.white,
                      ),
                      onPressed: snapshot.hasData && snapshot.data == false
                          ? () async {
                              _clickController.add(true);
                              setState(() {
                                _menuAlignment = Alignment.center;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              openContainer();
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                _menuAlignment = Alignment.centerRight;
                              });
                              _clickController.add(false);
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        alignment: _menuAlignment,
        child: topMenu(),
      );
    });
  }
}
