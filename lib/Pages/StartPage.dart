import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import '../Objects/AppProvider.dart';
import '../Objects/Carre.dart';
import '../Objects/UserPreferences.dart';
import 'dart:io';
import 'dart:convert';
import 'GamePage.dart';
import 'TopMenu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartPage extends StatefulWidget {
  late int _source;

  StartPage(this._source, {super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late bool _isSlelected;
  final transitionType = ContainerTransitionType.fadeThrough;
  final TextEditingController textFieldController = TextEditingController();
  late bool _KeyOK;
  late int _diffInd;
  late int _sizeInd;
  late List<String> _diffList;
  late List<int> _sizeListInt;
  late List<double> _diffListDouble;
  late List<String> _sizeList;
  late double _currentOpacityDiff;
  late double _currentOpacitySize;
  late List<String> _kakuroListBySize;
  late String _sourceText;
  bool _continueGame = false;

  @override
  void initState() {
    super.initState();
    _KeyOK = false;
    _isSlelected = false;
    _diffInd = 0;
    _sizeInd = 0;
    _sizeList = ["8x8", "10x10", "12x12", "16x16"];
    _sizeListInt = [8, 10, 12, 16];
    _diffListDouble = [0.8, 0.5, 0.2];
    _currentOpacityDiff = 1.0;
    _currentOpacitySize = 1.0;
    _kakuroListBySize = [
      "lib/assets/images/kakuro8x8.png",
      "lib/assets/images/kakuro8x8.png",
      "lib/assets/images/kakuro8x8.png",
      "lib/assets/images/kakuro8x8.png"
    ];
  }

  void initLocaliz() {
    _diffList = [
      AppLocalizations.of(context)!.easy,
      AppLocalizations.of(context)!.medium,
      AppLocalizations.of(context)!.hard
    ];

    switch (widget._source) {
      case 0:
        _sourceText = AppLocalizations.of(context)!.solo;
        break;
      case 1:
        _sourceText = AppLocalizations.of(context)!.create;
        break;
      case 2:
        _sourceText = AppLocalizations.of(context)!.join;
        break;
    }
  }

  List<Widget> childrenList(int source) {
    List<Widget> children = [];
    switch (source) {
      case 0:
        UserPreferences.getGame().isEmpty
            ? children = [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 3,
                  child: AnimatedOpacity(
                    opacity: _currentOpacitySize,
                    duration: const Duration(milliseconds: 200),
                    child: Image.asset(
                      _kakuroListBySize[_sizeInd],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                diffSelector(),
                sizeSelector(),
              ]
            : children = [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                            "PARTIE TROUVÉE",
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            )
                        ),
                    Text(
                        "Voulez vous continuer votre partie ?",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 25
                        )
                    ),
                    Text("Si vous répondez non elle sera écrasée",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: UserPreferences.bgBtn,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: UserPreferences.btnColor,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: UserPreferences.btnColor,
                                size: MediaQuery.of(context).size.width / 15,
                              ),
                              onPressed: () {
                                UserPreferences.clearGame();
                                setState(() {});
                              },
                            )),
                        Container(
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: UserPreferences.bgBtn,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: UserPreferences.btnColor,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.check,
                                color: UserPreferences.btnColor,
                                size: MediaQuery.of(context).size.width / 15,
                              ),
                              onPressed: () {
                                _continueGame = true;
                                Navigator.of(context)
                                    .push(_gamePageRoute("", 0, widget._source));
                              },
                            )),
                      ],
                    ),
                  ]),
                )
              ];
        break;
      case 1:
        children = [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 3,
            child: AnimatedOpacity(
              opacity: _currentOpacitySize,
              duration: const Duration(milliseconds: 200),
              child: Image.asset(
                _kakuroListBySize[_sizeInd],
                fit: BoxFit.contain,
              ),
            ),
          ),
          diffSelector(),
          sizeSelector(),
          _KeyOK
              ? Icon(
                  Icons.check,
                  color: UserPreferences.btnColor,
                  size: 50,
                )
              : _isSlelected
                  ? SizedBox(
                      height: 50,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: UserPreferences.btnColor,
                      )))
                  : const SizedBox(
                      height: 40,
                    ),
        ];
        break;

      case 2:
        children = [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width / 1.5,
            child: TextField(
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                cursorColor: UserPreferences.btnColor,
                style: const TextStyle(
                  fontSize: 35,
                ),
                controller: textFieldController,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    isDense: false,
                    fillColor: UserPreferences.bgColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: UserPreferences.btnColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: UserPreferences.btnColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'XXXX-YYYY',
                    hintStyle: TextStyle(
                      color: UserPreferences.bgBtn,
                      fontSize: 30,
                    ))),
          ),
          Padding(
              padding: const EdgeInsets.all(40),
              child: AutoSizeText(
                AppLocalizations.of(context)!.k_desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: UserPreferences.btnColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ))
        ];
        break;
    }
    return children;
  }

  Widget diffSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
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
              setState(() {
                _currentOpacityDiff = 0.0;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  _diffInd = (_diffInd - 1) % _diffList.length;
                  _currentOpacityDiff = 1.0;
                });
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: AnimatedOpacity(
            opacity: _currentOpacityDiff,
            duration: const Duration(milliseconds: 200),
            child: AutoSizeText(
              _diffList[_diffInd],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: UserPreferences.btnColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: UserPreferences.bgBtn,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: UserPreferences.btnColor,
            ),
            onPressed: () {
              setState(() {
                _currentOpacityDiff = 0.0;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  _diffInd = (_diffInd + 1) % _diffList.length;
                  _currentOpacityDiff = 1.0;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  Widget sizeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
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
              setState(() {
                _currentOpacitySize = 0.0;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  _sizeInd = (_sizeInd - 1) % _sizeList.length;
                  _currentOpacitySize = 1.0;
                });
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: AnimatedOpacity(
            opacity: _currentOpacitySize,
            duration: const Duration(milliseconds: 200),
            child: AutoSizeText(
              _sizeList[_sizeInd],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: UserPreferences.btnColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: UserPreferences.bgBtn,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: UserPreferences.btnColor,
            ),
            onPressed: () {
              setState(() {
                _currentOpacitySize = 0.0;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  _sizeInd = (_sizeInd + 1) % _sizeList.length;
                  _currentOpacitySize = 1.0;
                });
              });
            },
          ),
        ),
      ],
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

  Widget midWidget(int source) {
    return Container(
        color: UserPreferences.bgColor,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
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
        text: _sourceText,
        selectedTextColor: UserPreferences.btnColor,
        transitionType: TransitionType.LEFT_TO_RIGHT,
        isSelected: _isSlelected,
        backgroundColor: UserPreferences.btnColor,
        selectedBackgroundColor: UserPreferences.bgColor,
        borderRadius: 15,
        borderWidth: 2,
        borderColor: UserPreferences.btnColor,
        textStyle: TextStyle(
            fontSize: 30,
            letterSpacing: 1,
            color: UserPreferences.bgColor,
            fontWeight: FontWeight.w400),
        onPress: () async {
          setState(() {
            _isSlelected = !_isSlelected;
          });
          await Future.delayed(const Duration(milliseconds: 500));

          if (_sourceText == AppLocalizations.of(context)!.create) {
            final json = await createParty();
            setState(() {
              _KeyOK = true;
            });
            String KEY = json["key"];
            int PORT = json["port"] as int;
            await Future.delayed(const Duration(milliseconds: 200));
            Navigator.of(context)
                .push(_gamePageRoute(KEY, PORT, widget._source));
          } else if (_sourceText == AppLocalizations.of(context)!.join) {
            String KEY = textFieldController.text.split("-")[0];
            int PORT = int.parse(textFieldController.text.split("-")[1]);
            Navigator.of(context)
                .push(_gamePageRoute(KEY, PORT, widget._source));
          } else if (_sourceText == AppLocalizations.of(context)!.solo) {
            Navigator.of(context).push(_gamePageRoute("", 0, widget._source));
          }
          setState(() {
            _isSlelected = !_isSlelected;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initLocaliz();
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: UserPreferences.bgColor,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15,
                    right: 20,
                    left: 20),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [returnBtn(), TopMenu("StartPage")],
                ),
              ),
              midWidget(widget._source),
              playButton(),
            ])),
      );
    });
  }

  Route _gamePageRoute(String key, int port, int source) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GamePage(
          _diffListDouble[_diffInd],
          _sizeListInt[_sizeInd],
          key,
          port,
          source,
          _continueGame),
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

  /*-------------------------------------Creation de partie multi-------------------------------------*/
  late Socket socket;
  final String _IP_SERVER = "192.168.0.42";
  final int _MAIN_SERVER_PORT = 8080;

  dynamic createParty() async {
    late final jsonData;
    final data = {
      "density": _diffListDouble[_diffInd],
      "size": _sizeListInt[_sizeInd],
      // Ajouter la matrice du jeu génére par le créateur de la partie (c'est le client qui la génère car cela pourrai surcharger le serveur)
    };
    final jData = jsonEncode(data);
    try {
      final socket = await Socket.connect(_IP_SERVER, _MAIN_SERVER_PORT);
      print("Connexion au serveur principal sur le port $_MAIN_SERVER_PORT");

      final input = const Utf8Decoder().bind(socket);
      socket.write(jData);
      final responseBytes = await input.first;
      jsonData = jsonDecode(responseBytes);

      // Fermeture de la connexion avec le serveur principal
      socket.destroy();
    } catch (e) {
      print("Erreur lors de la connexion au serveur : $e");
    }

    return jsonData;
  }
}
