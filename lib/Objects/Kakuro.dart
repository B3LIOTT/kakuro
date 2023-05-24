import 'dart:io';
import 'dart:math';

import 'package:kakuro/Objects/UserPreferences.dart';

import 'Carre.dart';

class Kakuro {
  late List<List<Carre>> board;
  late List<List<Carre>> reveivedBoard;
  int size;
  double density;
  List possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<List<int>> wrongL = [];
  bool continueGame;
  int score = 0;
  List<List<Carre>> get getBoard {
    return board;
  }

  /// Constructeur de la classe Kakuro
  /// size: taille du kakuro
  /// density: densité du kakuro
  /// board: tableau de carrés
  Kakuro(this.size, this.density, this.continueGame, this.reveivedBoard) {
    if (!continueGame && reveivedBoard.isEmpty) {
      board = List.generate(
          size, (i) => List.filled(size, Carre(0, 0, 0), growable: false),
          growable: false);
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          if (i == 0 || j == 0) {
            // first line and first column are black squares
            board[i][j] = Carre(-1, -1, -1);
          } else if (i == size - 1 || j == size - 1) {
            // last line and last column are black squares
            board[i][j] = Carre(-1, -1, -1);
          } else {
            // other squares are white squares
            if (board[i][j].value != -1) {
              board[i][j] = Carre(0, 0, 0);
            }
          }
        }
      }
      generateBlackSquares(); // on génère les carrés noirs
      fillWhiteSpaces(); // On s'assure qu'il n'existe pas de trop grandes séries de cases blanches
      fillBoard(); // On remplit les cases blanches avec des chiffres
      fillSums(); // On génère les sommes
      removeValues(); // On supprime les chiffres pour laisser des cases blanches vides
      score = calcScore();
    } else if (continueGame) {
      size = UserPreferences.getSize;
      density = UserPreferences.getDensity;
      board = UserPreferences.getGame();
    } else if (reveivedBoard.isNotEmpty) {
      board = reveivedBoard;
    }
  }

  /// Fonction qui génère les carrés noirs (en fonction d'une densité donnée)
  /// Aucune série de carrés blancs ne doit faire plus de 9 cases
  /// Il y a une symétrie central des carrés noirs (180°)
  /// Les sommes de 1 chiffre sont interdites
  void generateBlackSquares() {
    // Pour être sur qu'il n'y aura pas de cases vide, on met (density * (size - 2)²) * 20% carrés noirs
    // placés aléatoirement
    int nbBlackSquares = (0.17 * density * (size - 2) * (size - 2)).round();
    int x0, y0;
    for (int i = 0; i < nbBlackSquares; i++) {
      x0 = Random().nextInt(size - 2) + 1;
      y0 = Random().nextInt(size - 2) + 1;
      if (board[x0][y0].value == 0) {
        board[x0][y0] = Carre(-1, -1, -1);
        board[size - 1 - x0][size - 1 - y0] = Carre(-1, -1, -1);
      } else {
        i--;
      }
    }

    int x = Random().nextInt(100);
    if (x < density * 100) {
      // on teste pour la première case de la première ligne
      board[1][1] = Carre(-1, -1, -1); // et sa symétrie
      board[size - 2][size - 2] = Carre(-1, -1, -1);
    }
    x = Random().nextInt(100);
    if (x < density * 100) {
      // on teste pour la dernière case de la première ligne
      board[1][size - 2] = Carre(-1, -1, -1); // et sa symétrie
      board[size - 2][1] = Carre(-1, -1, -1);
    }

    // On parcourt la première ligne sans les premières et dernières cases
    // si les 2 cases à gauche, et à droite sont blanches on peut mettre un carré noir
    // sinon on doit avoir un carré noir d'un coté et deux cases blanches de l'autre
    for (int i = 2; i < size - 2; i++) {
      x = Random().nextInt(100);
      if (x < density * 100) {
        // un carré noir d'un côté ou d'un autre, et 2 blancs de l'autre
        if (board[1][i - 1].value == -1 &&
            board[1][i + 1].value == 0 &&
            board[1][i + 2].value == 0) {
          board[1][i] = Carre(-1, -1, -1);
          board[size - 2][size - 2 - i + 1] = Carre(-1, -1, -1);
        } else if (board[1][i - 1].value == 0 &&
            board[1][i - 2].value == 0 &&
            board[1][i + 1].value == -1) {
          board[1][i] = Carre(-1, -1, -1);
          board[size - 2][size - 2 - i + 1] = Carre(-1, -1, -1);
        }
        // 2 blancs des deux côtés
        else if (board[1][i - 1].value == 0 &&
            board[1][i - 2].value == 0 &&
            board[1][i + 1].value == 0 &&
            board[1][i + 2].value == 0) {
          board[1][i] = Carre(-1, -1, -1);
          board[size - 2][size - 2 - i + 1] = Carre(-1, -1, -1);
        }
      }
    }
    // On parcourt la 1ere colonne sans les premières et dernières cases
    // si les 2 cases au dessus, et en dessous sont blanches on peut mettre un carré noir
    // sinon on doit avoir un carré noir d'un coté et deux cases blanches de l'autre
    for (int i = 2; i < size - 2; i++) {
      x = Random().nextInt(100);
      if (x < density * 100) {
        // un carré noir d'un côté ou d'un autre, et 2 blancs de l'autre
        if (board[i - 1][1].value == -1 &&
            board[i + 1][1].value == 0 &&
            board[i + 2][1].value == 0) {
          board[i][1] = Carre(-1, -1, -1);
          board[size - 2 - i + 1][size - 2] = Carre(-1, -1, -1);
        } else if (board[i - 1][1].value == 0 &&
            board[i - 2][1].value == 0 &&
            board[i + 1][1].value == -1) {
          board[i][1] = Carre(-1, -1, -1);
          board[size - 2 - i + 1][size - 2] = Carre(-1, -1, -1);
        }
        // 2 blancs des deux côtés
        else if (board[i - 1][1].value == 0 &&
            board[i - 2][1].value == 0 &&
            board[i + 1][1].value == 0 &&
            board[i + 2][1].value == 0) {
          board[i][1] = Carre(-1, -1, -1);
          board[size - 2 - i + 1][size - 2] = Carre(-1, -1, -1);
        }
      }
    }

    // cas général
    for (int i = 2; i < size - 2; i++) {
      for (int j = 2; j < size - 2; j++) {
        // on cherche une case dont toutes les 2 cases adjacentes sont blanches
        if (board[i][j].value == 0 &&
            board[i - 1][j].value == 0 &&
            board[i - 2][j].value == 0 &&
            board[i + 1][j].value == 0 &&
            board[i + 2][j].value == 0 &&
            board[i][j - 1].value == 0 &&
            board[i][j - 2].value == 0 &&
            board[i][j + 1].value == 0 &&
            board[i][j + 2].value == 0) {
          // on regarde si elle doit être noire
          x = Random().nextInt(100);
          if (x < density * 100) {
            // si elle doit être noire, on la rend noire et on considère les cases sensibles (liste grise)
            board[i][j] = Carre(-1, -1, -1);
            board[size - 2 - i + 1][size - 2 - j + 1] =
                Carre(-1, -1, -1); // et sa symétrie
          }
        }
      }
    }
  }

  /// Fonction permettant d'inserer un carre noir pour completer une sequence trop longue de cases blanches
  void fillWhiteSpaces() {
    // Dans un premier temps, on construit la liste de toutes séquences de cases blanches horizontales
    List<List<int>> whiteSpaces = [];
    int start = 1;
    for (int i = 1; i < size - 1; i++) {
      // on cherche la première case blanche de la première ligne
      while (board[1][start].value == -1) {
        start++;
      }
      for (int j = start; j < size - 1; j++) {
        List<int> whiteSpace = blockSizeCoo(i, j, 1);
        whiteSpaces.add(whiteSpace);
        j += whiteSpace[2] - 1;
      }
    }
    // On parcourt la liste des séquences de cases blanches horizontales
    for (int i = 0; i < whiteSpaces.length; i++) {
      // Si la séquence est trop longue, on insère un carré noir au milieu des deux cases blanches
      if (whiteSpaces[i][2] > 9) {
        board[whiteSpaces[i][0]][whiteSpaces[i][1] + whiteSpaces[i][2] ~/ 2] =
            Carre(-1, -1, -1);
        board[size - 2 - whiteSpaces[i][0] + 1]
                [size - 2 - (whiteSpaces[i][1] + whiteSpaces[i][2] ~/ 2) + 1] =
            Carre(-1, -1, -1);
      }
    }

    // On fait pareil pour les séquences de cases blanches verticales
    whiteSpaces = [];
    for (int i = 1; i < size - 1; i++) {
      // on cherche la première case blanche de la première colonne
      start = 1;
      while (board[start][1].value == -1) {
        start++;
      }
      for (int j = start; j < size - 1; j++) {
        List<int> whiteSpace = blockSizeCoo(i, j, 0);
        whiteSpaces.add(whiteSpace);
        j += whiteSpace[2] - 1;
      }
    }
    // On parcourt la liste des séquences de cases blanches verticales
    for (int i = 0; i < whiteSpaces.length; i++) {
      // Si la séquence est trop longue, on insère un carré noir au milieu des deux cases blanches
      if (whiteSpaces[i][2] > 9) {
        board[whiteSpaces[i][0] + whiteSpaces[i][2] ~/ 2][whiteSpaces[i][1]] =
            Carre(-1, -1, -1);
        board[size - 2 - (whiteSpaces[i][0] + whiteSpaces[i][2] ~/ 2) + 1]
            [size - 2 - whiteSpaces[i][1] + 1] = Carre(-1, -1, -1);
      }
    }
    // tant qu'il existe des cases blanches contraintes, on les remplit
    List<int> constrained = isBoardConstrained();
    while (constrained[0] != -1) {
      board[constrained[0]][constrained[1]] = Carre(-1, -1, -1);
      board[size - 2 - constrained[0] + 1][size - 2 - constrained[1] + 1] =
          Carre(-1, -1, -1);
      constrained = isBoardConstrained();
    }
  }

  /// Fonction permettant de verifier si le plateau est contraint ou non
  /// (i,j) != (-1,-1) : carré contraint
  /// (-1,-1) : carré non contraint
  List<int> isBoardConstrained() {
    for (int i = 1; i < size - 1; i++) {
      for (int j = 1; j < size - 1; j++) {
        if (isConstrained(i, j) != -1) {
          return [i, j];
        }
      }
    }
    return [-1, -1];
  }

  /// Fonction permettant de vérifier si le carré est contraint ou non
  /// Un carré est contraint s'il est entouré de carrés noirs sur les côtés (soit gauche et droite, soit haut et bas)
  /// 0 : carré contraint
  /// -1 : carré non contraint
  int isConstrained(int i, int j) {
    if (board[i][j].value == 0) {
      // un carré est contraint soit s'il est entre deux carrés noirs horizontalement
      if (board[i][j - 1].value == -1 && board[i][j + 1].value == -1) {
        return 0;
      }
      // soit s'il est entre deux carrés noirs verticalement
      if (board[i - 1][j].value == -1 && board[i + 1][j].value == -1) {
        return 0;
      }
    }
    return -1;
  }

  /// Fonction qui retourne la taille d'un bloc depuis une coordonnée précisée et qui renvoie les coordonnées du début du bloc
  /// @param i : coordonnée i du bloc depuis lequel on part
  /// @param j : coordonnée j du bloc depuis lequel on part
  /// @param orientation : orientation du bloc (1: horizontal, 0: vertical)
  /// @return {id : int, jd : int, taille : int} : id et jd sont les coordonnées du début du bloc, taille est la taille du bloc
  List<int> blockSizeCoo(int i, j, orientation) {
    /*Définition des variables*/
    int id = -1;
    int jd = -1;
    int taille = 0;
    /*Si l'orientation est horizontale*/
    if (orientation == 0) {
      /*On cherche la première case du bloc*/
      while (board[i][j].value != -1) {
        i--;
      }
      /*On sauvegarde les coordonnées de la première case du bloc*/
      id = i;
      jd = j;
      /*On cherche la dernière case du bloc et on compte le nombre de cases*/
      while (board[i + 1][j].value != -1) {
        taille++;
        i++;
      }
      /*On ajoute 1 à la taille pour prendre en compte la dernière case*/
      taille++;
      /* On crée la liste qui comporte les coordonnées du début du bloc et la taille du bloc*/
      List<int> list = [id, jd, taille];
      /*On retourne la liste*/
      wrongL.add(list +
          [
            orientation
          ]); // on ajoute la liste à la liste des blocs mal placés pour l'affichage graphique
      return list;
    }
    /*Si l'orientation est verticale*/
    else {
      /*On cherche la première case du bloc*/
      while (board[i][j].value != -1) {
        j--;
      }
      /*On sauvegarde les coordonnées de la première case du bloc*/
      id = i;
      jd = j;
      /*On cherche la dernière case du bloc et on compte le nombre de cases*/
      while (board[i][j + 1].value != -1) {
        taille++;
        j++;
      }
      /*On ajoute 1 à la taille pour prendre en compte la dernière case*/
      taille++;
      /* On crée la liste qui comporte les coordonnées du début du bloc et la taille du bloc*/
      List<int> list = [id, jd, taille];
      /*On retourne la liste*/
      wrongL.add(list +
          [
            orientation
          ]); // on ajoute la liste à la liste des blocs mal placés pour l'affichage graphique
      return list;
    }
  }

  /// Fonction qui rempli les cases blanches du plateau avec des chiffres aléatoires
  bool fillBoard() {
    for (int row = 1; row < size - 1; row++) {
      for (int col = 1; col < size - 1; col++) {
        if (board[row][col].value == 0) {
          List<int> possibleValues = getPossibleValues(row, col);
          if (possibleValues.isEmpty) {
            return false;
          }

          int randomIndex = Random().nextInt(possibleValues.length);
          board[row][col].value = possibleValues[randomIndex];

          if (fillBoard()) {
            return true;
          } else {
            board[row][col].value = 0;
          }
        }
      }
    }
    return true;
  }

  /// Fonction permettant de retourner la liste des valeurs possibles pour un carré
  /// @param row : coordonnée i du carré
  /// @param col : coordonnée j du carré
  List<int> getPossibleValues(int row, int col) {
    List<int> possibleValues = List.generate(9, (i) => i + 1);
    List<int> squaresBlockVertical = blockSizeCoo(
        row, col, 0); // On récupère les coordonnées du bloc vertical
    List<int> squaresBlockHorizontal = blockSizeCoo(
        row, col, 1); // On récupère les coordonnées du bloc horizontal
    // On parcours les carrés du bloc vertical et on enlève les valeurs déjà présentes
    for (int i = squaresBlockVertical[0];
        i < squaresBlockVertical[0] + squaresBlockVertical[2];
        i++) {
      if (board[i][col].value != 0) {
        possibleValues.remove(board[i][col].value);
      }
    }
    // On parcours les carrés du bloc horizontal et on enlève les valeurs déjà présentes
    for (int j = squaresBlockHorizontal[1];
        j < squaresBlockHorizontal[1] + squaresBlockHorizontal[2];
        j++) {
      if (board[row][j].value != 0) {
        possibleValues.remove(board[row][j].value);
      }
    }
    return possibleValues;
  }

  /// Fonction qui permet de compléter les Verticals et les Horizontals Sums en déduisant depuis les carrés blancs complétés
  void fillSums() {
    for (int row = 0; row < size - 1; row++) {
      for (int col = 0; col < size - 1; col++) {
        if ((row != 0 || col != 0) && board[row][col].value == -1) {
          int horizontalSum = 0;
          int verticalSum = 0;

          // Calculate horizontal sum
          int currentCol = col + 1;
          while (currentCol < size && board[row][currentCol].value != -1) {
            horizontalSum += board[row][currentCol].value;
            currentCol++;
          }

          // Calculate vertical sum
          int currentRow = row + 1;
          while (currentRow < size && board[currentRow][col].value != -1) {
            verticalSum += board[currentRow][col].value;
            currentRow++;
          }

          // Assign sums to the Carre object
          if (horizontalSum == 0 && verticalSum == 0) {
            board[row][col].horizontalSum = -1;
            board[row][col].verticalSum = -1;
          } else if (horizontalSum == 0) {
            board[row][col].horizontalSum = -1;
            board[row][col].verticalSum = verticalSum;
          } else if (verticalSum == 0) {
            board[row][col].horizontalSum = horizontalSum;
            board[row][col].verticalSum = -1;
          } else {
            board[row][col].horizontalSum = horizontalSum;
            board[row][col].verticalSum = verticalSum;
          }
        }
      }
    }
  }

  /// Fonction qui retourne la somme d'un bloc
  /// @param row : coordonnée i du bloc
  /// @param col : coordonnée j du bloc
  /// @param orientation : 0 pour vertical, 1 pour horizontal
  int blockSum(int row, int col, int orientation) {
    List<int> squaresBlock = blockSizeCoo(row, col, orientation);
    int sum = 0;
    if (orientation == 0) {
      for (int i = squaresBlock[0] + 1;
          i < squaresBlock[0] + squaresBlock[2];
          i++) {
        sum += board[i][col].value;
      }
    } else {
      for (int j = squaresBlock[1] + 1;
          j < squaresBlock[1] + squaresBlock[2];
          j++) {
        sum += board[row][j].value;
      }
    }
    return sum;
  }

  /// Fonction qui vérifie si le plateau est solution
  /// @return la liste vide si le plateau est solution, sinon la liste des coordonnées des blocs qui ne sont pas solution
  List<List<int>> checkSolution() {
    wrongL.isNotEmpty ? wrongL.clear() : null;
    List<List<int>> list = [];
    for (int row = 1; row < size - 1; row++) {
      for (int col = 1; col < size - 1; col++) {
        if (board[row][col].value == -1 &&
            (board[row][col].horizontalSum != -1 ||
                board[row][col].verticalSum != -1)) {
          if (board[row][col].horizontalSum != -1) {
            if (board[row][col].horizontalSum != blockSum(row, col, 1)) {
              List<int> list2 = [row, col];
              list.add(list2);
            } else {
              wrongL.removeAt(wrongL.length - 1);
            }
          }
          if (board[row][col].verticalSum != -1) {
            if (board[row][col].verticalSum != blockSum(row, col, 0)) {
              List<int> list2 = [row, col];
              list.add(list2);
            } else {
              wrongL.removeAt(wrongL.length - 1);
            }
          }
        }
      }
    }
    return list;
  }

  /// Fonction qui détermine si le plateau est solution
  /// @return true si le plateau est solution, false sinon
  bool isSolution() {
    return checkSolution().isEmpty;
  }

  /// Fonction qui vide les valeurs des carrés blancs
  void removeValues() {
    for (int row = 1; row < size - 1; row++) {
      for (int col = 1; col < size - 1; col++) {
        if (board[row][col].value != -1) {
          board[row][col].value = 0;
        }
      }
    }
  }

  /// Fonction qui détermine s'il n'y a qu'un seul carré blanc dans un bloc vertical
  /// @param row : coordonnée i du bloc
  /// @param col : coordonnée j du bloc
  bool countWhiteSquaresV(int row, int col) {
    // On parcourt le bloc et on compte petit à petit le nombre de carrés blancs
    // Si on en trouve plus d'1, on retourne false
    int count = 0;
    List<int> vBlock = blockSizeCoo(row, col, 0);
    for (int i = vBlock[0] + 1; i < vBlock[0] + vBlock[2]; i++) {
      if (board[i][col].value == 0) {
        count++;
      }
      if (count > 1) {
        return false;
      }
    }
    return true;
  }

  /// Fonction qui détermine s'il n'y a qu'un seul carré blanc dans un bloc horizontal
  /// @param row : coordonnée i du bloc
  /// @param col : coordonnée j du bloc
  bool countWhiteSquaresH(int row, int col) {
    // On parcourt le bloc et on compte petit à petit le nombre de carrés blancs
    // Si on en trouve plus d'1, on retourne false
    int count = 0;
    List<int> hBlock = blockSizeCoo(row, col, 1);
    for (int j = hBlock[1] + 1; j < hBlock[1] + hBlock[2]; j++) {
      if (board[row][j].value == 0) {
        count++;
      }
      if (count > 1) {
        return false;
      }
    }
    return true;
  }

  /// Fonction qui retourne la liste des valeurs possibles pour une case
  /// En considérant cette fois les sommes horizontales et verticales
  /// @param row : coordonnée i de la case
  /// @param col : coordonnée j de la case
  /// @return la liste des valeurs possibles pour la case
  List<int> getPossibleValuesv2(int row, int col) {
    List<int> possibleValues = getPossibleValues(
        row, col); // Toutes les valeurs possibles pour la case
    List<int> squaresBlockHorizontal =
    blockSizeCoo(row, col, 1); // Coordonnées du bloc horizontal
    List<int> squaresBlockVertical =
    blockSizeCoo(row, col, 0); // Coordonnées du bloc vertical
    List<int> valuesToRemove = [];

    // On teste d'abord pour le bloc horizontal
    // On est dans le cas ou une seule case est vide
    if (countWhiteSquaresH(row, col)) {
      int sum = blockSum(row, col, 1);
      for (int value in possibleValues) {
        // Si la somme de cette case et du reste n'est pas égal à la somme du bloc, on l'enlève
        if (sum + value !=
            board[squaresBlockHorizontal[0]][squaresBlockHorizontal[1]]
                .horizontalSum) {
          valuesToRemove.add(value);
        }
      }
    }
    // On est dans le cas ou plusieurs cases sont vides
    else {
      int sum = blockSum(row, col, 1);
      if (sum != 0) {
        // On enlève les valeurs qui causent une somme supérieure à la somme du bloc
        for (int value in possibleValues) {
          if (sum + value >
              board[squaresBlockHorizontal[0]][squaresBlockHorizontal[1]]
                  .horizontalSum) {
            valuesToRemove.add(value);
          }
        }
      }
    }

    // On est dans le cas ou une seule case est vide
    if (countWhiteSquaresV(row, col)) {
      int sum = blockSum(row, col, 0);
      // Si la somme de cette case et du reste n'est pas égal à la somme du bloc, on l'enlève
      for (int value in possibleValues) {
        if (sum + value !=
            board[squaresBlockVertical[0]][squaresBlockVertical[1]]
                .verticalSum) {
          valuesToRemove.add(value);
        }
      }
    }
    // On est dans le cas ou plusieurs cases sont vides
    else {
      // On enlève les valeurs qui causent une somme supérieure à la somme du bloc
      int sum = blockSum(row, col, 0);
      if (sum != 0) {
        // On enlève les valeurs qui causent une somme supérieure à la somme du bloc
        for (int value in possibleValues) {
          if (sum + value >
              board[squaresBlockVertical[0]][squaresBlockVertical[1]]
                  .verticalSum) {
            valuesToRemove.add(value);
          }
        }
      }
    }

    for (int value in valuesToRemove) {
      possibleValues.remove(value);
    }

    return possibleValues;
  }

  /// Fonction qui permet de résoudre un plateau
  /// @return true si le plateau est solution, false sinon
  bool solveKakuro() {
    // Pour chaque case vide
    for (int row = 1; row < size - 1; row++) {
      for (int col = 1; col < size - 1; col++) {
        if (board[row][col].value == 0) {
          List<int> possibleValues = getPossibleValuesv2(row, col);
          // on teste chaque valeur possible pour cette case
          for (int value in possibleValues) {
            board[row][col].value = value;
            if (solveKakuro()) {
              return true;
              // sinon on remet la valeur à 0, on passe à la valeur suivante
            } else {
              board[row][col].value = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }


  /// Fonction qui calcule un score basé sur le nombre de possibilités pour chaque case
  /// @return le score du plateau
  int calcScore() {
    int score = 0;
    for (int row = 1; row < size - 1; row++) {
      for (int col = 1; col < size - 1; col++) {
        if (board[row][col].value == 0) {
          score += getPossibleValues(row, col).length;
        }
      }
    }
    return score;
  }

  /// Fonction qui permet d'afficher dans la console le plateau de jeu
  void printBoard() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j].value == -1) {
          if (board[i][j].verticalSum == -1 &&
              board[i][j].horizontalSum == -1) {
            stdout.write("XXXXX ");
          } else if (board[i][j].verticalSum == -1) {
            // On ajoute un espace si la somme horizontale est inférieure à 10
            if (board[i][j].horizontalSum < 10) {
              stdout.write("  \\${board[i][j].horizontalSum}  ");
            } else {
              stdout.write("  \\${board[i][j].horizontalSum} ");
            }
          } else if (board[i][j].horizontalSum == -1) {
            // On ajoute un espace si la somme verticale est inférieure à 10
            if (board[i][j].verticalSum < 10) {
              stdout.write(" ${board[i][j].verticalSum}\\   ");
            } else {
              stdout.write("${board[i][j].verticalSum}\\   ");
            }
          } else {
            // On ajoute la bonne quantité d'espace pour que les sommes soient alignées
            if (board[i][j].horizontalSum < 10) {
              if (board[i][j].verticalSum < 10) {
                stdout.write(
                    " ${board[i][j].verticalSum}\\${board[i][j].horizontalSum}  ");
              } else {
                stdout.write(
                    "${board[i][j].verticalSum}\\${board[i][j].horizontalSum}  ");
              }
            } else {
              if (board[i][j].verticalSum < 10) {
                stdout.write(
                    " ${board[i][j].verticalSum}\\${board[i][j].horizontalSum} ");
              } else {
                stdout.write(
                    "${board[i][j].verticalSum}\\${board[i][j].horizontalSum} ");
              }
            }
          }
        } else {
          stdout.write("  ${board[i][j].value}   ");
        }
      }
      stdout.write("\n");
    }
  }
}

/// Fonction qui teste le temps moyen de génération d'une grille
/// @param n : nombre de grilles à générer
/// @param size : taille de la grille
/// @param density : densité de la grille
void testTime(int n, int size, double density) {
  Stopwatch stopwatch = Stopwatch()..start();
  for (int i = 0; i < n; i++) {
    Kakuro(size, density, false, []);
  }
  print(
      'Temps moyen de génération de $n grilles de taille $size : ${stopwatch.elapsedMilliseconds / n} ms');
}
