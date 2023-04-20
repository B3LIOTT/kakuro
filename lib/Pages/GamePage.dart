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

  GamePage(this._diff, this._size, this._KEY, this._PORT, this._source, {super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  void initState() {
    super.initState();
    if (widget._source == "CREER") {
      connexionHandlerFromCreate(widget._KEY, widget._PORT);
    } else if (widget._source == "REJOINDRE") {
      connexionHandlerFromJoin(widget._KEY, widget._PORT);
    }
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
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: UserPreferences.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: UserPreferences.bgBtn,
          borderRadius: BorderRadius.circular(20),
        ),
      )
    );
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
                  children: [returnBtn(), const TopMenu()],
                ),
              ),
                  kakuro(),

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
