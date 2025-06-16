import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getLeaderboardStream() {
    return _db
        .collection('leaderboard')
        .orderBy('completedLevels', descending: true)
        .limit(20)
        .snapshots();
  }

  Future<void> updateUserScore(String name, int completedLevels) async {
    final docRef = _db.collection('leaderboard').doc(name);
    await docRef.set({
      'name': name,
      'completedLevels': completedLevels,
    }, SetOptions(merge: true));
  }
}
