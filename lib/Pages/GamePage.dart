import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Objects/AppProvider.dart';
import '../Objects/UserPreferences.dart';
import 'TopMenu.dart';

class GamePage extends StatefulWidget {
  late final String _diff;
  late final String _size;
  late final String _source;
  late final int _PORT;
  late final String _KEY;

  GamePage(this._diff, this._size, this._KEY, this._PORT, this._source,
      {super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late bool _isKakuroLoading;
  late int _size;
  late List<bool> _whatsSelected;

  @override
  void initState() {
    super.initState();
    _size = int.parse(widget._size[0]);
    if (widget._source == "CREER") {
      connexionHandlerFromCreate(widget._KEY, widget._PORT);
    } else if (widget._source == "REJOINDRE") {
      connexionHandlerFromJoin(widget._KEY, widget._PORT);
    }
    _isKakuroLoading = true;
    _whatsSelected = List.filled(_size * _size, false);
    genKakuro();
  }

  void genKakuro() async {
    await Future.delayed(const Duration(
        seconds: 1)); // TODO: remove this, ca sert juste a voir le loading
    setState(() {
      _isKakuroLoading = false;
    });
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

  Widget kakuro() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Container(
            margin: const EdgeInsets.all(20),
            child: _isKakuroLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: UserPreferences.btnColor,
                  ))
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _size * _size,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _size),
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                          child: InkWell(
                            customBorder: const CircleBorder(),
                              onTap: () {
                                setState(() {
                                  _whatsSelected[index] = true;
                                });
                              },
                              child: Stack(
                                children: [
                                  _whatsSelected[index]
                                      ? Container(
                                    decoration: BoxDecoration(
                                      color: UserPreferences.bgBtn,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                      : Container(),
                                  Center(child: Text(
                                    "0",
                                    style: TextStyle(
                                      color: UserPreferences.btnColor,
                                      fontSize: 30,
                                    ),
                                  )),
                                ],
                              )));
                    },
                  )));
  }

  Widget numPad() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: UserPreferences.bgBtn,
          borderRadius: BorderRadius.circular(20),
        ),
        child: GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: List.generate(
              10,
              (index) => Container(
                    decoration: BoxDecoration(
                      color: UserPreferences.bgBtn,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: UserPreferences.btnColor,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: Text(
                        (index != 9) ? (index + 1).toString() : "X",
                        style: TextStyle(
                          color: UserPreferences.btnColor,
                          fontSize: 30,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )),
        ));
  }

  @override
  Widget build(BuildContext context) {
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
                  children: [returnBtn(), TopMenu("GamePage")],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    kakuro(),
                    Text("${widget._diff} - ${widget._size}"),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      top: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 20),
                  alignment: Alignment.bottomCenter,
                  child: numPad(),
                ),
              ),
            ])),
      );
    });
  }

  /*------------------------ Echange de données avec le serveur ------------------------*/

  late Socket socket;
  final String _IP_SERVER = "192.168.1.21";
  List<List<int>> _gameMatrix = [];

  void connexionHandlerFromCreate(String KEY, int PORT) {
    // Fonction qui gère les données reçues du serveur (le port et la clé du serveur privé)

    print("Serveur privé => $KEY-$PORT");

    // Connexion au serveur privé
    try {
      Socket.connect(_IP_SERVER, PORT).then((Socket sock) {
        socket = sock;
        final input = const Utf8Decoder().bind(sock);

        // Envoi de la clé au serveur privé
        final key = jsonEncode(KEY);
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

  void connexionHandlerFromJoin(String KEY, int PORT) {
    try {
      Socket.connect(_IP_SERVER, PORT).then((Socket sock) {
        socket = sock;
        final input = const Utf8Decoder().bind(sock);

        // Envoi de la clé au serveur privé
        final key = jsonEncode(KEY);
        socket.write(key);

        input.listen(dataHandler,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      });
    } catch (e) {
      print("Erreur lors de la connexion au serveur : $e");
    }
  }
}
