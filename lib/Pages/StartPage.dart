import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import '../main.dart';
import 'Menu.dart';
import 'dart:io';
import 'dart:convert';

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
  String _KeySTR = "";
  late int _diffInd;
  late List<String> _diffList;

  @override
  void initState() {
    super.initState();
    _isSlelected = false;
    _menuAlignment = Alignment.centerRight;
    _diffInd = 0;
    _diffList = ["8x8", "10x10", "12x12", "16x16"];
  }

  List<Widget> childrenList(String source) {
    List<Widget> children = [];

    switch (source) {
      case "SOLO":
        children = [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width / 2,
            child: AnimatedButton(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              text: "CONTINUER",
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
          ),
          diffSelector(),
        ];
        break;
      case "CREER":
        children = [
          (_KeySTR != "")
              ? Text(
                  "Clé: " + _KeySTR,
                  style: const TextStyle(
                    fontSize: 30,
                    color: MyApp.btnColor,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Text("Attente de la clé du serveur privé"),
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
                    hintText: 'XXXX-YYYY',
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

  Widget diffSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: MyApp.bgBtn,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _diffInd = (_diffInd - 1) % 4;
              });
            },
          ),
        ),
        Text(_diffList[_diffInd],
            style: const TextStyle(
              fontSize: 30,
              color: MyApp.btnColor,
              fontWeight: FontWeight.w400,
            )),
        Container(
          decoration: const BoxDecoration(
            color: MyApp.bgBtn,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _diffInd = (_diffInd + 1) % 4;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget returnBtn() {
    return Container(
      decoration: const BoxDecoration(
        color: MyApp.bgBtn,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget TopMenu() {
    return OpenContainer(
      closedElevation: 0,
      closedColor: MyApp.bgColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      transitionType: transitionType,
      transitionDuration: const Duration(milliseconds: 500),
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
                  _menuAlignment = Alignment.centerLeft;
                });
                await Future.delayed(const Duration(milliseconds: 200));
                setState(() {
                  _menuAlignment = Alignment.centerRight;
                });
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  _menuAlignment = Alignment.centerLeft;
                });
                await Future.delayed(const Duration(milliseconds: 200));
                setState(() {
                  _menuAlignment = Alignment.centerRight;
                });
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  _menuAlignment = Alignment.centerLeft;
                });
                await Future.delayed(const Duration(milliseconds: 200));
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
        height: MediaQuery.of(context).size.height / 2,
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

          switch (widget._source) {
            case "CREER":
              final json = await createParty();
              setState(() {
                _KeySTR = json["key"] + "-" + json["port"].toString();
              });
              break;
            case "REJOINDRE":
              _KeySTR = textFieldController.text.split("-")[0];
              joinParty(
                  _KeySTR, int.parse(textFieldController.text.split("-")[1]));
              break;
            case "SOLO":
              break;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyApp.bgColor,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10),
                height: MediaQuery.of(context).size.height / 5,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    returnBtn(),
                    AnimatedContainer(
                      width: MediaQuery.of(context).size.width / 1.5,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200),
                      alignment: _menuAlignment,
                      child: TopMenu(),
                    )
                  ],
                )),
            midWidget(widget._source),
            playButton(),
            (widget._source == "REJOINDRE")
                ? const Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(40),
                        child: AutoSizeText(
                          "Demandez le code de la partie à celui qui l'a créé, il est de la forme : \nXXXXX-YYYY \navec X une lettre majuscule et Y un chiffre",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MyApp.btnColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        )))
                : const Expanded(child: SizedBox()),
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

  /*-------------------------------------Creation de partie multi-------------------------------------*/
  late Socket socket;
  final String _IP_SERVER = "192.168.106.36";
  final int _MAIN_SERVER_PORT = 8080;
  List<List<int>> _gameMatrix = [];

  dynamic createParty() async {
    late final jsonData;
    try {
      final socket = await Socket.connect(_IP_SERVER, _MAIN_SERVER_PORT);
      print("Connexion au serveur principal sur le port $_MAIN_SERVER_PORT");

      final input = Utf8Decoder().bind(socket).take(1);
      final responseBytes = await input.first;
      jsonData = json.decode(responseBytes);

      // Fermeture de la connexion avec le serveur principal
      socket.destroy();
    } catch (e) {
      print("Erreur lors de la connexion au serveur : $e");
    }

    // Connexion au serveur privé
    connexionHandlerFromCreate(jsonData);

    return jsonData;
  }

  void connexionHandlerFromCreate(jsonData) {
    // Fonction qui gère les données reçues du serveur (le port et la clé du serveur privé)

    print("Serveur privé => $jsonData");

    // Connexion au serveur privé
    try {
      Socket.connect(_IP_SERVER, jsonData["port"]).then((Socket sock) {
        socket = sock;
        final input = Utf8Decoder().bind(sock);

        // Envoi de la clé au serveur privé
        final key = jsonEncode(jsonData["key"]);
        socket.write(key);

        input.listen(dataHandler,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      });
    } catch (e) {
      print("Erreur lors de la connexion au serveur privé : $e");
    }
  }

  void dataHandler(String data) {
    // Fonction qui gère les données reçues du serveur privé (la matrice de jeu)

    // Conversion de la liste d'entiers en matrice de jeu
    final dynamicMatrix = jsonDecode(data);
    List<List<int>> matrix = List<List<int>>.generate(
        dynamicMatrix.length,
        (i) => List<int>.generate(
            dynamicMatrix[i].length, (j) => dynamicMatrix[i][j]));

    updateGame(matrix);
    print("Matrice du jeu : $_gameMatrix");
  }

  void updateGame(List<List<int>> matrix) {
    // Actualisation de la matrice du jeu
    _gameMatrix = matrix;
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
  }

  /*-------------------------------------Rejoindre de partie multi-------------------------------------*/
  late final int _PORT;
  late final String _KEY;

  void joinParty(String KEY, int PORT) {
    _PORT = PORT;
    _KEY = KEY;
    try {
      Socket.connect(_IP_SERVER, _PORT).then((Socket sock) {
        socket = sock;
        final input = Utf8Decoder().bind(sock);

        // Envoi de la clé au serveur privé
        final key = jsonEncode(_KEY);
        socket.write(key);

        input.listen(dataHandler,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      });
    } catch (e) {
      print("Erreur lors de la connexion au serveur : $e");
    }
  }
}
