import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  final Set<int> _completedLevelIds = {};

  Set<int> get completedLevelIds => _completedLevelIds;

  void completeLevel(int levelId) {
    _completedLevelIds.add(levelId);
    notifyListeners();
    // TODO: Save progress to SharedPreferences
  }

  bool isLevelCompleted(int levelId) {
    return _completedLevelIds.contains(levelId);
  }
}
