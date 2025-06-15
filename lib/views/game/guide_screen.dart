import 'package:flutter/material.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:learn_game/views/game/test_screen.dart';
import 'package:material_symbols_icons/symbols.dart';

class GuideScreen extends StatelessWidget {
  static const routeName = '/guide';

  const GuideScreen({super.key, required this.level});

  final Level level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(level.title),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: Icon(Symbols.lightbulb, size: 18),
              label: Text('Гайд'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    level.guideText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Symbols.quiz),
              label: const Text('Пройти тест'),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(TestScreen.routeName, arguments: level);
              },
            ),
          ],
        ),
      ),
    );
  }
}
