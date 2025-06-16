import 'package:flutter/foundation.dart';
import 'package:learn_game/data/services/leaderboard_service.dart';
import 'package:learn_game/providers/name_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider with ChangeNotifier {
  List<int> _completedLevels = [];
  SharedPreferences? _prefs;
  final LeaderboardService _leaderboardService = LeaderboardService();
  NameProvider? _nameProvider;

  List<int> get completedLevels => _completedLevels;

  ProgressProvider() {
    _init();
  }

  void updateNameProvider(NameProvider nameProvider) {
    _nameProvider = nameProvider;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCompletedLevels();
  }

  void _loadCompletedLevels() {
    final completed = _prefs?.getStringList('completedLevels');
    if (completed != null) {
      _completedLevels = completed.map((id) => int.parse(id)).toList();
    }
    notifyListeners();
  }

  Future<void> completeLevel(int levelId) async {
    if (!_completedLevels.contains(levelId)) {
      _completedLevels.add(levelId);
      final completed = _completedLevels.map((id) => id.toString()).toList();
      await _prefs?.setStringList('completedLevels', completed);

      if (_nameProvider != null) {
        await _leaderboardService.updateUserScore(
          _nameProvider!.name,
          _completedLevels.length,
        );
      }

      notifyListeners();
    }
  }

  bool isCompleted(int levelId) {
    return _completedLevels.contains(levelId);
  }

  Future<void> resetProgress() async {
    // We might want to clear the user's score in Firestore as well,
    // but for now, we'll just clear it locally.
    _completedLevels = [];
    await _prefs?.remove('completedLevels');
    if (_nameProvider != null) {
      await _leaderboardService.updateUserScore(_nameProvider!.name, 0);
    }
    notifyListeners();
  }
}
