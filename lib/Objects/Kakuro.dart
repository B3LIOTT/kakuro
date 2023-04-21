import 'dart:math';

import 'Carre.dart';

class Kakuro {
  late List<List<Carre>> board;
  int size;
  double density;
  List possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List valueUsed = [];

  List<List<Carre>> get getBoard {
    return board;
  }

  Kakuro(this.size, this.density) {
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
          if (board[i][j] != -1) {
            board[i][j] = Carre(0, 0, 0);
          }
        }
      }
    }
    generateBlackSquares();
    fillWhiteSpaces();
  }

  /**
   * Fonction qui génère les carrés noirs (en fonction d'une densité donnée)
   * No line or line of white cells can have a length greater than the range of the puzzle (1-9)
   * Black cells should have a 180 degree rotational symmetry
   * 1-cell sums should be avoided (at least 2 cells per sum)
   */
  void generateBlackSquares() {
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

  /** Fonction permettant d'insérer un carré noir pour compléter une séquence trop longue de cases blanches
   *
   */
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
        board[whiteSpaces[i][0]][whiteSpaces[i][1] + whiteSpaces[i][2] ~/ 2] = Carre(-1, -1, -1);
        board[size - 2 - whiteSpaces[i][0] + 1][size - 2 - (whiteSpaces[i][1] + whiteSpaces[i][2] ~/ 2) + 1] = Carre(-1, -1, -1);
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
        board[whiteSpaces[i][0] + whiteSpaces[i][2] ~/ 2][whiteSpaces[i][1]] = Carre(-1, -1, -1);
        board[size - 2 - (whiteSpaces[i][0] + whiteSpaces[i][2] ~/ 2) + 1][size - 2 - whiteSpaces[i][1] + 1] = Carre(-1, -1, -1);
      }
    }
    // tant qu'il existe des cases blanches contraintes, on les remplit
    while (isBoardConstrained()) {
      for (int i = 1; i < size - 1; i++) {
        for (int j = start; j < size - 1; j++) {
          if (isConstrained(i, j) != -1){
            board[i][j] = Carre(-1, -1, -1);
            board[size - 2 - i + 1][size - 2 - j + 1] = Carre(-1, -1, -1);
          }
        }
      }
    }
  }

  /** Fonction permettant de vérifier si le plateau est contraint ou non
   * 1 : plateau contraint
   * -1 : plateau non contraint
   */
  bool isBoardConstrained() {
    for (int i = 1; i < size - 1; i++) {
      for (int j = 1; j < size - 1; j++) {
        if (isConstrained(i, j) != -1) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Fonction permettant de vérifier si le carré est contraint ou non
   * Un carré est contraint s'il est entouré de carrés noirs sur les côtés (soit gauche et droite, soit haut et bas)
   * 0 : carré contraint
   * -1 : carré non contraint
   */
  int isConstrained(int i, int j) {
    if (board[i][j].value == 0) {
      if (board[i][j - 1].value == -1 && board[i][j + 1].value == -1) {
        return 0;
      }
      if (board[i - 1][j].value == -1 && board[i + 1][j].value == -1) {
        return 0;
      }
    }
    return -1;
  }

  /**
   * Fonction qui retourne la taille d'un bloc depuis une coordonnée précisée et qui renvoie les coordonnées du début du bloc
   * @param i : coordonnée i du bloc depuis lequel on part
   * @param j : coordonnée j du bloc depuis lequel on part
   * @param orientation : orientation du bloc (1: horizontal, 0: vertical)
   * @return {id : int, jd : int, taille : int} : id et jd sont les coordonnées du début du bloc, taille est la taille du bloc
   */
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
      while (board[i+1][j].value != -1) {
        taille++;
        i++;
      }
      /*On ajoute 1 à la taille pour prendre en compte la dernière case*/
      taille++;
      /* On crée la liste qui comporte les coordonnées du début du bloc et la taille du bloc*/
      List<int> list = [id, jd, taille];
      /*On retourne la liste*/
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
      while (board[i][j+1].value != -1) {
        taille++;
        j++;
      }
      /*On ajoute 1 à la taille pour prendre en compte la dernière case*/
      taille++;
      /* On crée la liste qui comporte les coordonnées du début du bloc et la taille du bloc*/
      List<int> list = [id, jd, taille];
      /*On retourne la liste*/
      return list;
    }
  }

  /**
   * Fonction permettant de vérifier si la valeur du carré est déjà présente dans la ligne et/ou la colonne où se trouve le carré
   * @param i : coordonnée i du carré
   * @param j : coordonnée j du carré
   * @return bool : false si la valeur est présente dans la ligne et/ou la colonne, true sinon
   * */
  bool verifValue(i, j) {
    /*On sauvegarde les valeurs initiales de i,j et de la valeur du carré*/
    int initI = i;
    int initJ = j;
    int valueIn = board[i][j].value;
    /*Tant que la valeur n'est pas -1, on vérifie si la valeur est présente à droite du carré*/
    while (board[i][j].value != -1) {
      j++;
      if (board[i][j].value == valueIn) {
        return false;
      }
    }
    /*On remet j à sa valeur initiale*/
    j = initJ;
    /*Tant que la valeur n'est pas -1, on vérifie si la valeur est présente à gauche du carré*/
    while (board[i][j].value != -1) {
      j--;
      if (board[i][j].value == valueIn) {
        return false;
      }
    }
    /*On remet i à sa valeur initiale*/
    j = initJ;
    /*Tant que la valeur n'est pas -1, on vérifie si la valeur est présente au dessus du carré*/
    while (board[i][j].value != -1) {
      i--;
      if (board[i][j].value == valueIn) {
        return false;
      }
    }
    /*On remet j à sa valeur initiale*/
    i = initI;
    /*Tant que la valeur n'est pas -1, on vérifie si la valeur est présente en dessous du carré*/
    while (board[i][j].value != -1) {
      i++;
      if (board[i][j].value == valueIn) {
        return false;
      }
    }
    /*Si la valeur n'est pas présente dans la ligne ni dans la colonne, on retourne true*/
    return true;
  }

  /**
   * Fonction récursive qui permet de remplir une colonne avec des valeurs aléatoires comprises entre 1 et 9
   * @param i : coordonnée i du bloc depuis lequel on part
   * @param j : coordonnée j du bloc depuis lequel on part
   */

  void rempliColRecur(int i, j) {
    /*Définition des variables*/
    int value = 0;
    /*On vérifie si on a atteint la fin du bloc*/
    if (board[i][j].value == -1) {
      /*Si on a atteint la fin du bloc, on vide la liste valueUsed*/
      valueUsed.clear();
      /*On retourne à la fonction appelante*/
      return;
    }
    /*Si on a pas atteint la fin du bloc*/
    else {
      /*On choisit une valeur aléatoire dans la liste possibleValues qui n'est pas dans la liste valueUsed*/
      do {
        value = possibleValues[Random().nextInt(possibleValues.length)];
      } while (valueUsed.contains(value));
      /*On modifie la valeur de la case*/
      board[i][j].value = value;
      /*On vérifie avec la fonction verifValue si la valeur choisie est valide*/
      if (verifValue(i, j)) {
        /*On ajoute la valeur à la liste valueUsed*/
        valueUsed.add(value);
        /*On appelle la fonction rempliColRecur avec la case suivante*/
        rempliColRecur(i++, j);
      } else {
        /*Si la valeur n'est pas valide, on remet la valeur de la case à -1*/
        board[i][j].value = -1;
        /*On ajoute la valeur à la liste valueUsed*/
        valueUsed.add(value);
        /*On appelle la fonction rempliColRecur avec la même case*/
        rempliColRecur(i, j);
      }
    }
  }

  /**
   * Fonction qui détermine où on appelle la fonction rempliColRecur
   */
  void whereFillCol() {
    /*Définition des variables*/
    int i = 0;
    int j = 1;
    /*On parcourt le tableau*/
    for (i; i < size - 2; i++) {
      for (j; j < size - 2; j++) {
        /*Cas 1 : Une case noire se situe en (i,j) et une case noire se situe en (i+1,j)*/
        if ((board[i][j].value == -1) && (board[i++][j].value == -1)) {
          /*On passe à la case suivante*/
          j++;
        }
        /*Cas 2 : Une case noire se situe en (i,j) et une case blanche se situe en (i+1,j)*/
        else if ((board[i][j].value == -1) && (board[i++][j].value == 0)) {
          /*On appelle la fonction rempliColonne pour remplir la colonne de valeurs aléatoires*/
          i++;
          rempliColRecur(i, j);
          i--;
          /*On passe à la case suivante*/
          j++;
        }
        /*Cas 3 : On parcourt une case blanche*/
        else if (board[i][j].value == 0) {
          /*On passe à la case suivante*/
          j++;
        }
      }
    }
  }

  /**Fonction permettant de vérifier si la somme des valeurs des carrés correspond à la somme horizontale
   * On appelle cette fonction uniquement sur les blocs noirs qui ont une somme horizontale
   * @param i : coordonnée i du carré
   * @param j : coordonnée j du carré
   * @return bool : false si la somme des valeurs des carrés est différente de la somme horizontale, true sinon
   */
  bool verifHorizontalSum(int i, j) {
    /*On crée un entier qui va contenir la somme des valeurs des carrés*/
    int sum = 0;
    /*On sauvegarde la valeur initiale de j*/
    int initJ = j;
    /*On se décalle à droite du carré*/
    j++;
    /*Tant que la valeur n'est pas -1, on ajoute la valeur du carré à la somme*/
    while (board[i][j].value != -1) {
      sum += board[i][j].value;
      j++;
    }
    /*Si la somme est différente de la somme horizontale, on retourne false*/
    if (sum != board[i][initJ].horizontalSum) {
      return false;
    }
    /*Sinon on retourne true*/
    return true;
  }

  /**Fonction permettant de vérifier si la somme des valeurs des carrés correspond à la somme verticale.
   * On appelle cette fonction uniquement sur les blocs noirs qui ont une somme verticale
   * @param i : coordonnée i du carré
   * @param j : coordonnée j du carré
   * @return bool : false si la somme des valeurs des carrés est différente de la somme verticale, true sinon
   * */
  bool verifVerticalSum(int i, j) {
    /*On crée un entier qui va contenir la somme des valeurs des carrés*/
    int sum = 0;
    /*On sauvegarde la valeur initiale de j*/
    int initI = i;
    /*On se décalle en dessous du carré*/
    i++;
    /*Tant que la valeur n'est pas -1, on ajoute la valeur du carré à la somme*/
    while (board[i][j].value != -1) {
      sum += board[i][j].value;
      i++;
    }
    /*Si la somme est différente de la somme verticale, on retourne false*/
    if (sum != board[initI][j].verticalSum) {
      return false;
    }
    /*Sinon on retourne true*/
    return true;
  }

  /**
   * Fonction de vérification du jeu qui sera appelé à la demande de l'utilisateur pour vérifier si ses valeurs sont correctes
   * @return 1 si la grille est correcte
   * @return 2 si le cas 2 n'est pas respecté
   * @return 3 si le cas 3 n'est pas respecté
   * @return 2 ou 3 si l'une des condition du cas 4 n'est pas respectée
   * @return 5 si le cas 5 n'est pas respecté
   */
  int verificateur() {
    /*On initialise les entiers qui permettent de parcourir le tableau*/
    int i = 0;
    int j = 0;
    /*Tant qu'on a pas parcouru tout le tableau : */
    while ((i < size) && (j < size)) {
      /*Cas 1 : On vérifie si toutes les valeurs du carré sont -1. Cela permet ici de savoir
      si on est sur une case entiérement noire (c'est à dire sans somme indiquée)*/
      if ((board[i][j].verticalSum == -1) &&
          (board[i][j].horizontalSum == -1) &&
          (board[i][j].value == -1)) {
        /*Si on arrive à la fin de la ligne, on passe à la ligne suivante*/
        if (j == size) {
          j = 0;
          i++;
        }
        /*Sinon, on avance d'un carré vers la droite*/
        else {
          j++;
        }
      }
      /*Cas 2 : On vérifie si la verticalSum est différente de -1 et si la horizontalSum et la valeur du carré est -1. Cela permet ici de savoir
      si on est sur une case noire avec une somme verticale indiquée uniquement*/
      else if ((board[i][j].verticalSum != -1) &&
          (board[i][j].horizontalSum == -1) &&
          (board[i][j].value == -1)) {
        /*On lance la fonction de vérification de la somme verticale*/
        /*Si on est à la fin de la ligne, on passe à la ligne suivante*/
        if (verifVerticalSum(i, j)) {
          /*Si la somme verticale est correcte, on passe à la case suivante*/
          if (j == size) {
            j = 0;
            i++;
          }
          /*Sinon, on avance d'un carré vers la droite*/
          else {
            j++;
          }
        } else {
          /*Si la somme verticale est incorrecte, on retourne un message indiquant que le jeu n'est pas résolu à cause de la somme verticale en (i, j)*/
          return 2;
        }
      }
      /*Cas 3 : On vérifie si la horizontalSum est différente de -1 et si la verticalSum et la valeur du carré est -1. Cela permet ici de savoir
      si on est sur une case noire avec une somme horizontale indiquée uniquement*/
      else if ((board[i][j].verticalSum == -1) &&
          (board[i][j].horizontalSum != -1) &&
          (board[i][j].value == -1)) {
        /*On lance la fonction de vérification de la somme horizontale*/
        /*Si la somme horizontale est correcte, on passe à la case suivante*/
        if (verifHorizontalSum(i, j)) {
          /*Si on arrive à la fin de la ligne, on passe à la ligne suivante*/
          if (j == size) {
            j = 0;
            i++;
          }
          /*Sinon, on avance d'un carré vers la droite*/
          else {
            j++;
          }
        } else {
          /*Si la somme horizontale est incorrecte, on retourne un message indiquant que le jeu n'est pas résolu à cause de la somme horizontale en (i, j)*/
          return 3;
        }
      }
      /*Cas 4 : On vérifie si la verticalSum et la horizontalSum sont différente de -1 et si la valeur du carré est -1. Cela permet ici de savoir
      si on est sur une case noire avec une somme verticale et une somme horizontale indiquée*/
      else if ((board[i][j].verticalSum != -1) &&
          (board[i][j].horizontalSum != -1) &&
          (board[i][j].value == -1)) {
        /*On lance la fonction de vérification de la somme verticale*/
        if (verifVerticalSum(i, j)) {
          /*Si la somme verticale est correcte, on lance la fonction de vérification de la somme horizontale*/
          if (verifHorizontalSum(i, j)) {
            /*Si la somme horizontale est correcte, on passe à la case suivante*/
            /*Si on arrive à la fin de la ligne, on passe à la ligne suivante*/
            if (j == size) {
              j = 0;
              i++;
            }
            /*Sinon, on avance d'un carré vers la droite*/
            else {
              j++;
            }
          } else {
            /*Si la somme horizontale est incorrecte, on retourne un message indiquant que le jeu n'est pas résolu à cause de la somme horizontale en (i, j)*/
            return 3;
          }
        } else {
          /*Si la somme verticale est incorrecte, on retourne un message indiquant que le jeu n'est pas résolu à cause de la somme verticale en (i, j)*/
          return 2;
        }
      }
      /*Cas 5 : On vérifie si la valeur du carré est différente de -1. Cela permet ici de savoir
      si on est sur une case blanche*/
      else if (board[i][j].value != -1) {
        /*On lance la fonction de vérification qui permet de savoir si la valeur du carré est inscrite une fois et une seule dans la ligne et la colonne*/
        if (verifValue(i, j)) {
          /*Si la valeur du carré est inscrite une fois et une seule dans la ligne et la colonne :*/
          /*Si on arrive à la fin de la ligne, on passe à la ligne suivante*/
          if (j == size) {
            j = 0;
            i++;
          }
          /*Sinon, on avance d'un carré vers la droite*/
          else {
            j++;
          }
        } else {
          /*Si la valeur du carré n'est pas inscrite une fois et une seule dans la ligne et la colonne, on retourne un message indiquant que le jeu n'est pas résolu à cause de la valeur en (i, j)*/
          return 5;
        }
      }
    }
    /*On retourne un message indiquant que le jeu est résolu*/
    return 1;
  }

  void printBoard() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j].value == -1) {
          if (board[i][j].verticalSum == -1 &&
              board[i][j].horizontalSum == -1) {
            print("X ");
          } else if (board[i][j].verticalSum == -1) {
            print(board[i][j].horizontalSum.toString() + " ");
          } else if (board[i][j].horizontalSum == -1) {
            print(board[i][j].verticalSum.toString() + " ");
          } else {
            print(board[i][j].verticalSum.toString() +
                "\\" +
                board[i][j].horizontalSum.toString() +
                " ");
          }
        } else {
          print(board[i][j].value.toString() + " ");
        }
      }
      print("");
    }
  }
}