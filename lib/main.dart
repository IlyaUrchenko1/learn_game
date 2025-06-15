import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:learn_game/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU');
  runApp(const App());
}
