import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider with ChangeNotifier {
  List<int> _completedLevels = [];
  SharedPreferences? _prefs;

  List<int> get completedLevels => _completedLevels;

  ProgressProvider() {
    _init();
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
      notifyListeners();
    }
  }

  bool isCompleted(int levelId) {
    return _completedLevels.contains(levelId);
  }

  Future<void> resetProgress() async {
    _completedLevels = [];
    await _prefs?.remove('completedLevels');
    notifyListeners();
  }
}
