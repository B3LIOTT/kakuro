import 'package:cloud_firestore/cloud_firestore.dart';
import 'Player.dart';

class RankingRepo {
  static final _db = FirebaseFirestore.instance.collection('Ranking');

  static bool get isConnected => _db.snapshots().isBroadcast;

  static Stream<List<Player>> get rankingList {
    return _db.snapshots().map((snapshot) => snapshot.docs.map((doc) => Player(doc['username'], doc['RP'])).toList());
  }
}