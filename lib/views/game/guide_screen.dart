import 'package:flutter/material.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:learn_game/views/game/test_screen.dart';

class GuideScreen extends StatelessWidget {
  static const routeName = '/guide';

  const GuideScreen({super.key, required this.level});

  final Level level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(level.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  level.guideText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(TestScreen.routeName, arguments: level);
              },
              child: const Text('Пройти тест'),
            ),
          ],
        ),
      ),
    );
  }
}
