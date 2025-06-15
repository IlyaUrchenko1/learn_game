import 'package:flutter/material.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
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

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Результаты'),
            const SizedBox(width: 8),
            Chip(
              label: const Text('Результат'),
              backgroundColor: colorScheme.primaryContainer,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ваш результат',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: score / total,
                            strokeWidth: 8,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        Text(
                          '$score / $total',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    isPassed
                        ? Symbols.trophy_rounded
                        : Symbols.sentiment_dissatisfied_rounded,
                    size: 64,
                    color: isPassed ? colorScheme.primary : colorScheme.error,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isPassed
                        ? 'Поздравляем! Уровень пройден!'
                        : 'Вы не набрали достаточно очков.\nПопробуйте еще раз!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isPassed ? colorScheme.primary : colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Symbols.arrow_back_rounded),
                    label: const Text('Назад к уровням'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
