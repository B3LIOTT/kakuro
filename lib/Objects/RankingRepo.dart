import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Player.dart';

class RankingRepo {
  static final _db = FirebaseFirestore.instance.collection('Ranking');

  static bool get isConnected => _db.snapshots().isBroadcast;

  static Stream<List<Player>> get rankingList {
    return _db.snapshots().map((snapshot) => snapshot.docs.map((doc) => Player(doc['username'], doc['RP'])).toList());
  }

  static Future<bool> newPlayer(Player player) async {
    final doc = await _db.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (!doc.exists) {
      await _db.add({
        'username': player.username,
        'RP': 0,
      });
      return true;
    } else {
      return false;
    }
  }

  static Future<void> updatePlayer(Player player) async {
    await _db.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'RP': player.RP,
    });
  }

}