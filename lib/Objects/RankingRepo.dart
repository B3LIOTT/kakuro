import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'Player.dart';

class RankingRepo {
  static final _db = FirebaseFirestore.instance.collection('Ranking');
  static final _sorted_db = _db.orderBy("RP", descending: true);
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    result = await _connectivity.checkConnectivity();
    print(result);
    return (result != ConnectivityResult.none);
  }

  static Stream<List<Player>> get rankingList {
    return _sorted_db.snapshots().map((snapshot) => snapshot.docs.map((doc) => Player(doc['username'], doc['RP'])).toList());
  }

  static Future<void> updatePlayer(Player player, int size, double density, List<int> timer, double score) async {
    int sec = timer[2] + timer[1] * 60 + timer[0] * 3600;
    //List<int> sizes = [8, 10, 12, 16];
    //List<double> densities = [0.8, 0.5, 0.2];
    //final newRP = player.RP + (10 + 5*sizes.indexOf(size) + 3*densities.indexOf(density) +  60 / sqrt(sec)).round();
    final newRP = player.RP + (score/sqrt(sec)).round();
    await _db.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'RP': newRP,
    });
  }

  static Future<Player> get currentUser async {
    final player = await _db.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if(player.exists) {
      return Player(player['username'], player['RP']);
    }else {
      // Ajout du joueur dans la base de données si il n'existe pas
      final String username = FirebaseAuth.instance.currentUser!.displayName!;
      await _db.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'username': username,
        'RP': 0,
      });
      return Player(username, 0);
    }
  }

}