import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Уровень 1')),
      body: const Center(child: Text('Экран Игры (гайд и тест)')),
    );
  }
}
