import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kakuro/Objects/CustomBorder.dart';
import 'package:kakuro/Objects/Kakuro.dart';
import 'package:provider/provider.dart';
import '../Objects/AppProvider.dart';
import '../Objects/Carre.dart';
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
  late double _density;
  late List<bool> _whatsSelected;
  List<List<Carre>> _gameMatrix = [];

  @override
  void initState() {
    super.initState();
    switch (widget._size.length) {
      case 3:
        _size = int.parse(widget._size[0]);
        break;
      case 5:
        _size = int.parse(widget._size.substring(0, 2));
        break;
    }
    switch (widget._diff) {
      case "Facile":
        _density = 0.8;
        break;
      case "Moyen":
        _density = 0.5;
        break;
      case "Expert":
        _density = 0.3;
        break;
    }
    _isKakuroLoading = true;
    _whatsSelected = List.filled(_size * _size, false);
    genKakuro();

    if (widget._source == "CREER") {
      connexionHandlerFromCreate(widget._KEY, widget._PORT);
    } else if (widget._source == "REJOINDRE") {
      connexionHandlerFromJoin(widget._KEY, widget._PORT);
    }
  }

  void updateValue(int value) {
    for (int i = 0; i < _whatsSelected.length; i++) {
      if (_whatsSelected[i]) {
        setState(() {
          _gameMatrix[i ~/ _size][i % _size].value = (value < 10) ? value : 0;
          _whatsSelected[i] = false;
        });
      }
    }
  }

  void genKakuro() async {
    Kakuro kwakuro = Kakuro(_size, _density);
    setState(() {
      _gameMatrix = kwakuro.board;
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

  Widget carreKakuroGen(int index) {
    int i = index ~/ _size;
    int j = index % _size;
    Carre c = _gameMatrix[i][j];
    late Widget w;

    if (c.horizontalSum == -1 && c.verticalSum == -1 && c.value == -1) { //si c'est un carré noir
      w = Container(
      );
    } else if (c.horizontalSum > -1 && c.verticalSum == -1 && c.value == -1) { //si c'est un carré noir avec une somme horizontale
      w = Container(
        decoration: BoxDecoration(
          border : CustomBorder(
            color: UserPreferences.btnColor,
            width: 2.2 - _size.toDouble() * 0.0875,
            voidSize: 12 - _size.toDouble() * 0.5,
            hasDiagonal: true,
            hasLeft : ((j==0) || (_gameMatrix[i][j-1].horizontalSum == -1 && _gameMatrix[i][j-1].verticalSum == -1 && _gameMatrix[i][j-1].value == -1)) ? false : true,
            hasBottom : ((i==_size-1) || (_gameMatrix[i+1][j].horizontalSum == -1 && _gameMatrix[i+1][j].verticalSum == -1 && _gameMatrix[i+1][j].value == -1)) ? false : true,
          ),
        ),
      );
    } else if (c.horizontalSum == -1 && c.verticalSum > -1 && c.value == -1) { //si c'est un carré noir avec une somme verticale
      w = Container(
          decoration: BoxDecoration(
            border : CustomBorder(
              color: UserPreferences.btnColor,
              width: 2.2 - _size.toDouble() * 0.0875,
              voidSize: 12 - _size.toDouble() * 0.5,
              hasDiagonal: true,
              hasRight : ((j==_size-1) || (_gameMatrix[i][j+1].horizontalSum == -1 && _gameMatrix[i][j+1].verticalSum == -1 && _gameMatrix[i][j+1].value == -1)) ? false : true,
              hasTop : ((i==0) || (_gameMatrix[i-1][j].horizontalSum == -1 && _gameMatrix[i-1][j].verticalSum == -1 && _gameMatrix[i-1][j].value == -1)) ? false : true,
            ),
          ),
      );
    } else if (c.horizontalSum == 0 &&
        c.verticalSum == 0 &&
        (c.value >= 0 && c.value < 10)) {  //si c'est un carré blanc avec une valeur
      w = InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            setState(() {
              _whatsSelected[index] = !_whatsSelected[index];
            });
          },
          child: Stack(
            children: [
              _whatsSelected[index]
                  ? Opacity(
                  opacity: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: UserPreferences.bgBtn,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: UserPreferences.bgColor,
                        width: 5 - _size.toDouble() * 0.25,
                      ),
                    ),
                  ))
                  : Container(),
              Center(
                  child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border : CustomBorder(
                          color: UserPreferences.btnColor,
                          width: 2.2 - _size.toDouble() * 0.0875,
                          voidSize: 12 - _size.toDouble() * 0.5,
                          hasLeft : ((j==0) || (_gameMatrix[i][j-1].horizontalSum == -1 && _gameMatrix[i][j-1].verticalSum == -1 && _gameMatrix[i][j-1].value == -1)) ? false : true,
                          hasBottom : ((i==_size-1) || (_gameMatrix[i+1][j].horizontalSum == -1 && _gameMatrix[i+1][j].verticalSum == -1 && _gameMatrix[i+1][j].value == -1)) ? false : true,
                          hasRight : ((j==_size-1) || (_gameMatrix[i][j+1].horizontalSum == -1 && _gameMatrix[i][j+1].verticalSum == -1 && _gameMatrix[i][j+1].value == -1)) ? false : true,
                          hasTop : ((i==0) || (_gameMatrix[i-1][j].horizontalSum == -1 && _gameMatrix[i-1][j].verticalSum == -1 && _gameMatrix[i-1][j].value == -1)) ? false : true,
                        ),
                        ),
                  ),
                  Center(
                    child: Text(c.value.toString()),
                  )
                ],
              )),
            ],
          ));
    }
    else if (c.horizontalSum > 0 &&
        c.verticalSum > 0 &&
        (c.value == -1)) {
      print("$c");
      w = Stack(
            children: [
              Center(
                  child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border : CustomBorder(
                          color: UserPreferences.btnColor,
                            width: 2.2 - _size.toDouble() * 0.0875,
                            voidSize: 12 - _size.toDouble() * 0.5,
                          hasDiagonal: true
                        ),
                        ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(c.verticalSum.toString()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(c.horizontalSum.toString()),
                    ),
                  )
                ],
              )),
              _whatsSelected[index]
                  ? Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: UserPreferences.btnColor,
                          shape: BoxShape.circle,
                        ),
                      ))
                  : Container(),
            ],
          );
    }

    return w;
  }

  Widget kakuro() {
    return Container(
        height: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
        child: _isKakuroLoading
            ? Center(
                child: CircularProgressIndicator(
                color: UserPreferences.btnColor,
              ))
            : InteractiveViewer(
                panEnabled: true,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _size * _size,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _size),
                  itemBuilder: (BuildContext context, int index) {
                    return Center(child: carreKakuroGen(index));
                  },
                )));
  }

  Widget numPad() {
    return Container(
        margin: const EdgeInsets.only(right: 20, left: 20),
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
                alignment: Alignment.center,
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
                          fontSize: MediaQuery.of(context).size.width / 15,
                        ),
                      ),
                      onPressed: () {
                        updateValue(index + 1);
                      },
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
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  top: 20, bottom: MediaQuery.of(context).padding.bottom + 20),
              alignment: Alignment.bottomCenter,
              child: numPad(),
            ),
          ),
        ]),
      );
    });
  }

  /*------------------------ Echange de données avec le serveur ------------------------*/

  late Socket socket;
  final String _IP_SERVER = "192.168.1.21";

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

        // Envoi de la matrice de jeu au serveur privé pour qu'il la stocke et la diffuse aux autres joueurs qui arrivent
        final matrix = jsonEncode(_gameMatrix);
        socket.write(matrix);

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
    List<List<Carre>> matrixData = List<List<Carre>>.generate(
        data.length,
            (i) => List<Carre>.generate(
            dynamicMatrix[i].length, (j) => dynamicMatrix[i][j]));

    updateGame(matrixData);
    print("Matrice du jeu : $_gameMatrix");
  }

  void updateGame(List<List<Carre>> matrix) {
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
