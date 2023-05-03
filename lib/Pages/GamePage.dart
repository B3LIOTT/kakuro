import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kakuro/Objects/CustomBorder.dart';
import 'package:kakuro/Objects/Kakuro.dart';
import 'package:kakuro/Objects/TimerWidget.dart';
import 'package:provider/provider.dart';
import '../Objects/AppProvider.dart';
import '../Objects/Carre.dart';
import '../Objects/UserPreferences.dart';
import 'TopMenu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GamePage extends StatefulWidget {
  late double _diff;
  late int _size;
  late final int _source;
  late final int _PORT;
  late final String _KEY;
  late bool _continueGame;

  GamePage(this._diff, this._size, this._KEY, this._PORT, this._source, this._continueGame,
      {super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _isKakuroLoading = true;
  late int _size;
  late double _density;
  late List<bool> _whatsSelected;
  late Kakuro _kwakuro;
  late List<double> _opacities;
  late Color _verifyColor;
  late TimerWidget _timerWidget;


  @override
  void initState() {
    super.initState();
    _verifyColor = Colors.green;
    List<int> t_list = widget._continueGame? UserPreferences.getTimer : [0,0,0];
    _timerWidget = TimerWidget(t_list[0], t_list[1], t_list[2]);

    if(widget._source != 2) {
      _size = widget._size;
      _density = widget._diff;// si on veut rejoindre une partie (i.e widget._source == 2) l'initialisation se fera plus tard
      _opacities = List.generate(_size * _size, (index) => 0.0);
      _whatsSelected = List.filled(_size * _size, false);
      genKakuro(widget._continueGame);
    }
    if (widget._source == 1) {
      connexionHandlerFromCreate(widget._KEY, widget._PORT);
    } else if (widget._source == 2) {
      _density = 0.0;
      _size = 0;
      connexionHandlerFromJoin(widget._KEY, widget._PORT);
    }
    _timerWidget.startTimer();
  }

  void updateValue(int value) {
    for (int i = 0; i < _whatsSelected.length; i++) {
      if (_whatsSelected[i]) {
        setState(() {
          _kwakuro.board[i ~/ _size][i % _size].value =
              (value < 10) ? value : 0;
          _whatsSelected[i] = false;
        });
      }
    }
  }

  void genKakuro(bool continueGame) {
    setState(() {
      _kwakuro = Kakuro(_size, _density, continueGame);
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
          _timerWidget.stopTimer();
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  Widget carreKakuroGen(int index) {
    int i = index ~/ _size;
    int j = index % _size;
    Carre c = _kwakuro.board[i][j];
    late Widget w;

    if (c.horizontalSum == -1 && c.verticalSum == -1 && c.value == -1) {
      //si c'est un carré noir
      w = Container();
    } else if (c.horizontalSum > 0 && c.verticalSum == -1 && c.value == -1) {
      //si c'est un carré noir avec une somme horizontale
      w = Container(
        decoration: BoxDecoration(
          border: CustomBorder(
            color: UserPreferences.btnColor,
            width: 2.2 - _size.toDouble() * 0.0875,
            voidSize: 12 - _size.toDouble() * 0.5,
            hasDiagonal: true,
            hasLeft: ((j == 0) ||
                    (_kwakuro.board[i][j - 1].horizontalSum == -1 &&
                        _kwakuro.board[i][j - 1].verticalSum == -1 &&
                        _kwakuro.board[i][j - 1].value == -1))
                ? false
                : true,
            hasBottom: ((i == _size - 1) ||
                    (_kwakuro.board[i + 1][j].horizontalSum == -1 &&
                        _kwakuro.board[i + 1][j].verticalSum == -1 &&
                        _kwakuro.board[i + 1][j].value == -1))
                ? false
                : true,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              c.horizontalSum.toString(),
              style: TextStyle(
                fontSize: 104 / _size,
              ),
            ),
          ),
        ),
      );
    } else if (c.horizontalSum == -1 && c.verticalSum > -1 && c.value == -1) {
      //si c'est un carré noir avec une somme verticale
      w = Container(
        decoration: BoxDecoration(
          border: CustomBorder(
            color: UserPreferences.btnColor,
            width: 2.2 - _size.toDouble() * 0.0875,
            voidSize: 12 - _size.toDouble() * 0.5,
            hasDiagonal: true,
            hasRight: ((j == _size - 1) ||
                    (_kwakuro.board[i][j + 1].horizontalSum == -1 &&
                        _kwakuro.board[i][j + 1].verticalSum == -1 &&
                        _kwakuro.board[i][j + 1].value == -1))
                ? false
                : true,
            hasTop: ((i == 0) ||
                    (_kwakuro.board[i - 1][j].horizontalSum == -1 &&
                        _kwakuro.board[i - 1][j].verticalSum == -1 &&
                        _kwakuro.board[i - 1][j].value == -1))
                ? false
                : true,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              c.verticalSum.toString(),
              style: TextStyle(
                fontSize: 104 / _size,
              ),
            ),
          ),
        ),
      );
    } else if (c.horizontalSum == 0 &&
        c.verticalSum == 0 &&
        (c.value >= 0 && c.value < 10)) {
      //si c'est un carré blanc avec une valeur
      w = InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            setState(() {
              for (int i = 0; i < _whatsSelected.length; i++) {
                if (i != index) {
                  _whatsSelected[i] = false;
                } else {
                  _whatsSelected[i] = !_whatsSelected[i];
                }
              }
            });
          },
          child: Stack(
            children: [
              AnimatedOpacity(
                  opacity: _opacities[index],
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _verifyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
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
                      border: CustomBorder(
                        color: UserPreferences.btnColor,
                        width: 2.2 - _size.toDouble() * 0.0875,
                        voidSize: 12 - _size.toDouble() * 0.5,
                        hasLeft: ((j == 0) ||
                                (_kwakuro.board[i][j - 1].horizontalSum == -1 &&
                                    _kwakuro.board[i][j - 1].verticalSum ==
                                        -1 &&
                                    _kwakuro.board[i][j - 1].value == -1))
                            ? false
                            : true,
                        hasBottom: ((i == _size - 1) ||
                                (_kwakuro.board[i + 1][j].horizontalSum == -1 &&
                                    _kwakuro.board[i + 1][j].verticalSum ==
                                        -1 &&
                                    _kwakuro.board[i + 1][j].value == -1))
                            ? false
                            : true,
                        hasRight: ((j == _size - 1) ||
                                (_kwakuro.board[i][j + 1].horizontalSum == -1 &&
                                    _kwakuro.board[i][j + 1].verticalSum ==
                                        -1 &&
                                    _kwakuro.board[i][j + 1].value == -1))
                            ? false
                            : true,
                        hasTop: ((i == 0) ||
                                (_kwakuro.board[i - 1][j].horizontalSum == -1 &&
                                    _kwakuro.board[i - 1][j].verticalSum ==
                                        -1 &&
                                    _kwakuro.board[i - 1][j].value == -1))
                            ? false
                            : true,
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
    } else {
      w = Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: CustomBorder(
                    color: UserPreferences.btnColor,
                    width: 2.2 - _size.toDouble() * 0.0875,
                    voidSize: 12 - _size.toDouble() * 0.5,
                    hasDiagonal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  c.verticalSum.toString(),
                  style: TextStyle(
                    fontSize: 104 / _size,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  c.horizontalSum.toString(),
                  style: TextStyle(
                    fontSize: 104 / _size,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return w;
  }

  Widget kakuro() {
    return Container(
        height: MediaQuery.of(context).size.width-40,
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

  Widget verifyBtn() {
    return Container(
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
            verify();
          },
        ));
  }

  void verify() async {
    if (_kwakuro.isSolution()) {
      setState(() {
        _verifyColor = Colors.green;
        _timerWidget.stopTimer();
      });
      for (int index = 0; index < _opacities.length; index++) {
        _opacities[index] = 0.6;
      }
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 700));
      for (int index = 0; index < _opacities.length; index++) {
        _opacities[index] = 0.0;
      }
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 200));
      (widget._source == 1 || widget._source == 2)? GGonline() : GG();
    } else {
      setState(() {
        _verifyColor = Colors.red;
      });
      for (List<int> li in _kwakuro.wrongL) {
        if (li[3] == 1) {
          for (int i = 1; i < li[2]; i++) {
            _opacities[li[0] * _size + li[1] + i] = 0.6;
          }
        } else {
          for (int i = 1; i < li[2]; i++) {
            _opacities[(li[0] + i) * _size + li[1]] = 0.6;
          }
        }
      }
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 700));
      for (List<int> li in _kwakuro.wrongL) {
        if (li[3] == 1) {
          for (int i = 0; i < li[2]; i++) {
            _opacities[li[0] * _size + li[1] + i] = 0.0;
          }
        } else {
          for (int i = 0; i < li[2]; i++) {
            _opacities[(li[0] + i) * _size + li[1]] = 0.0;
          }
        }
      }
      setState(() {});
    }
  }

  void GG() {
    UserPreferences.clearGame();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: UserPreferences.bgColor,
        title: Text("VICTORY", style: TextStyle(color: UserPreferences.btnColor, fontWeight: FontWeight.bold)),
        content: Text("GG! You complete this Kakuro ${(_density == 0.2)? AppLocalizations.of(context)?.hard : (_density == 0.5)? AppLocalizations.of(context)?.medium : AppLocalizations.of(context)?.easy} - ${_size}x$_size in ${UserPreferences.getTimerString}", style: const TextStyle(color: Colors.black54)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('OK', style: TextStyle(color: UserPreferences.btnColor, fontSize: 20)),
          ),
        ],
      ),);
  }

  @override
  Widget build(BuildContext context) {
    if(widget._source == 0) {
      UserPreferences.setDensity(_density);
      UserPreferences.setSize(_size);
      UserPreferences.setGame(_kwakuro.board);
      UserPreferences.setTimer([_timerWidget.H, _timerWidget.M, _timerWidget.S]);
    }
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return WillPopScope(
        child:Scaffold(
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
              children: [
                _timerWidget,
                kakuro(),
                (widget._source == 1)? Text("${widget._KEY}-${widget._PORT}", style: const TextStyle(fontSize: 20),) : Container(),
                Text("${(_density == 0.2)? AppLocalizations.of(context)?.hard : (_density == 0.5)? AppLocalizations.of(context)?.medium : AppLocalizations.of(context)?.easy} - ${_size}x$_size"),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  top: 10, bottom: MediaQuery.of(context).padding.bottom + 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [verifyBtn(), numPad()]),
            ),
          ),
        ]),
      ),
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return true;
      });
    });
  }

  /*------------------------ Echange de données avec le serveur ------------------------*/

  late Socket socket;
  final String _IP_SERVER = "10.0.2.2";
  int _nbRequest = 0;

  void connexionHandlerFromCreate(String KEY, int PORT) {
    // Fonction qui gère les données reçues du serveur (le port et la clé du serveur privé)
    while(_isKakuroLoading) {}
    print("Serveur privé => $KEY-$PORT");

    // Connexion au serveur privé
    try {
      Socket.connect(_IP_SERVER, PORT).then((Socket sock) async {
        socket = sock;
        final input = const Utf8Decoder().bind(sock);

        // Envoi de la clé au serveur privé
        final key = jsonEncode(KEY);
        socket.write(key);

        await Future.delayed(const Duration(milliseconds: 200));
        // Envoi de la matrice de jeu au serveur privé pour qu'il la stocke et la diffuse aux autres joueurs qui arrivent
        await sendMatrix(socket, _kwakuro.board);

        input.listen(dataHandlerFromCreate,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      });
    } catch (e) {
      print("Erreur lors de la connexion au serveur privé : $e");
    }
  }

  void dataHandlerFromCreate(String data) {
    // Reception du message de fin de partie
    final jsonData = jsonDecode(data);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: UserPreferences.bgColor,
        title: Text("DEFEAT", style: TextStyle(color: UserPreferences.btnColor, fontWeight: FontWeight.bold)),
        content: Text("[Display winner pseudo] finished ${(_density == 0.2)? AppLocalizations.of(context)?.hard : (_density == 0.5)? AppLocalizations.of(context)?.medium : AppLocalizations.of(context)?.easy} - ${_size}x$_size in $jsonData", style: const TextStyle(color: Colors.black54)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('OK', style: TextStyle(color: UserPreferences.btnColor, fontSize: 20)),
          ),
        ],
      ),);

  }

  void updateGame(List<List<Carre>> matrix) {
    // Actualisation de la matrice du jeu
    setState(() {
      _kwakuro.board = matrix;
    });
    print("Matrice du jeu mise à jour");
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
  }

  /*-------------------------------------Rejoindre de partie multi-------------------------------------*/
  int _count = 0;
  String buffer = "";

  void connexionHandlerFromJoin(String KEY, int PORT) {
    try {
      Socket.connect(_IP_SERVER, PORT).then((Socket sock) {
        socket = sock;
        final input = const Utf8Decoder().bind(sock);

        // Envoi de la clé au serveur privé
        final key = jsonEncode(KEY);
        socket.write(key);

        input.listen(dataHandlerFromJoin,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      });
    } catch (e) {
      print("Erreur lors de la connexion au serveur : $e");
    }
  }

  void dataHandlerFromJoin(String data) {
    // Fonction qui gère les données reçues du serveur privé (la matrice de jeu)
    if (_nbRequest == 0) {
      // Reception de la difficulté et de la taille
      final decodedJson = jsonDecode(data);
      setState(() {
        _density = decodedJson["density"];
        _size = decodedJson["size"];
      });

      // Initialisation du Kakuro
      _opacities = List.generate(_size * _size, (index) => 0.0);
      _whatsSelected = List.filled(_size * _size, false);
      _kwakuro = Kakuro(_size, _density, false);

      _nbRequest++;
    } else if(_nbRequest <= _size){
      // Actualisation de la matrice du jeu
      buffer += data;
      _count++;
      if(_count == _size) {
        final jsonList = const LineSplitter().convert(buffer);
        print(buffer);
        List<List<Carre>> matrix = [];

        for (final json in jsonList) {
          final List<Carre> row = [];

          for (final carreJson in jsonDecode(json)) {
            final carre = Carre.fromJson(carreJson);
            row.add(carre);
          }
          matrix.add(row);
        }
        _count = 0;
        buffer = "";
        updateGame(matrix);
      }
      _isKakuroLoading = false;
      _timerWidget.startTimer();
      _nbRequest++;
    } else {
      // Reception du message de fin de partie
      final jsonData = jsonDecode(data);
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: UserPreferences.bgColor,
          title: Text("DEFEAT", style: TextStyle(color: UserPreferences.btnColor, fontWeight: FontWeight.bold)),
          content: Text("[Display winner pseudo] finished ${(_density == 0.2)? AppLocalizations.of(context)?.hard : (_density == 0.5)? AppLocalizations.of(context)?.medium : AppLocalizations.of(context)?.easy} - ${_size}x$_size in $jsonData", style: const TextStyle(color: Colors.black54)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('OK', style: TextStyle(color: UserPreferences.btnColor, fontSize: 20)),
            ),
          ],
        ),);
    }
  }

  /*-------------------------------------Fonctions-------------------------------------*/

  Future<void> sendMatrix(Socket socket, List<List<Carre>> board) async {
    for (final row in board) {
      final jsonRow = jsonEncode(row.map((c) => c.toJson()).toList());
      socket.write('$jsonRow\n');
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void GGonline() {
    UserPreferences.clearGame();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: UserPreferences.bgColor,
        title: Text("VICTORY", style: TextStyle(color: UserPreferences.btnColor, fontWeight: FontWeight.bold)),
        content: Text("GG! You complete this Kakuro ${(_density == 0.2)? AppLocalizations.of(context)?.hard : (_density == 0.5)? AppLocalizations.of(context)?.medium : AppLocalizations.of(context)?.easy} - ${_size}x$_size in ${UserPreferences.getTimerString}", style: const TextStyle(color: Colors.black54)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('OK', style: TextStyle(color: UserPreferences.btnColor, fontSize: 20)),
          ),
        ],
      ),);

    // Envoi du message de fin de partie au serveur
    final jsonData = jsonEncode(UserPreferences.getTimerString);
    socket.write(jsonData);
  }

}
