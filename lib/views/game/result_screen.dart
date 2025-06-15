import 'package:flutter/material.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result';

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.levelId,
  });

  final int score;
  final int total;
  final int levelId;

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );
    final bool isPassed = score / total >= 0.7;

    if (isPassed) {
      progressProvider.completeLevel(levelId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ваш результат: $score / $total',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              if (isPassed)
                const Text(
                  'Поздравляем! Уровень пройден!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                const Text(
                  'Вы не набрали достаточно очков. Попробуйте еще раз!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Назад к уровням'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
