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

  Future<void> updateUserPhone(String name, String? phone) async {
    final docRef = _db.collection('leaderboard').doc(name);
    await docRef.set({'phone': phone}, SetOptions(merge: true));
  }

  Future<String?> getPhoneNumber(String name) async {
    final docRef = _db.collection('leaderboard').doc(name);
    final doc = await docRef.get();
    if (doc.exists && doc.data()!.containsKey('phone')) {
      return doc.data()!['phone'] as String?;
    }
    return null;
  }
}
