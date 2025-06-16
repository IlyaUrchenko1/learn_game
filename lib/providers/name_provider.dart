import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameProvider with ChangeNotifier {
  String _name = 'Игрок';

  String get name => _name;

  NameProvider() {
    loadName();
  }

  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('userName') ?? 'Игрок';
    notifyListeners();
  }

  Future<void> saveName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newName);
    _name = newName;
    notifyListeners();
  }
}
