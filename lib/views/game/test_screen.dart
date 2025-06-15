import 'package:flutter/material.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:learn_game/models/test_model.dart';
import 'package:learn_game/views/game/result_screen.dart';
import 'package:material_symbols_icons/symbols.dart';

class TestScreen extends StatefulWidget {
  static const routeName = '/test';

  const TestScreen({super.key, required this.level});

  final Level level;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _hintUsed = false;
  List<int> _hiddenAnswers = [];

  void _answerQuestion(int selectedAnswerIndex) {
    if (selectedAnswerIndex ==
        widget.level.test[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex < widget.level.test.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _hintUsed = false;
        _hiddenAnswers = [];
      });
    } else {
      Navigator.of(context).pushReplacementNamed(
        ResultScreen.routeName,
        arguments: {
          'score': _score,
          'total': widget.level.test.length,
          'levelId': widget.level.id,
        },
      );
    }
  }

  void _useHint() {
    final correctAnswerIndex =
        widget.level.test[_currentQuestionIndex].correctAnswerIndex;
    final incorrectAnswers = widget.level.test[_currentQuestionIndex].answers
        .asMap()
        .keys
        .where((index) => index != correctAnswerIndex)
        .toList();

    incorrectAnswers.shuffle();

    setState(() {
      _hiddenAnswers = incorrectAnswers.take(2).toList();
      _hintUsed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = widget.level.test[_currentQuestionIndex];
    final theme = Theme.of(context);
    final progress = (_currentQuestionIndex + 1) / widget.level.test.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.title),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: Icon(Symbols.quiz, size: 18),
              label: Text('Тест'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Вопрос ${_currentQuestionIndex + 1}/${widget.level.test.length}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQuestion.question,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...currentQuestion.answers.asMap().entries.map((entry) {
              int idx = entry.key;
              String answerText = entry.value;

              if (_hiddenAnswers.contains(idx)) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FilledButton(
                  onPressed: () => _answerQuestion(idx),
                  child: Text(answerText),
                ),
              );
            }),
            const Spacer(),
            if (!_hintUsed)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextButton.icon(
                  onPressed: _useHint,
                  icon: const Icon(Symbols.lightbulb),
                  label: const Text('Подсказка 50/50'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
