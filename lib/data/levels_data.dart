import 'package:learn_game/models/level_model.dart';
import 'package:learn_game/models/test_model.dart';

final List<Level> allLevels = [
  Level(
    id: 1,
    title: "Уровень 1: Основы",
    guideText:
        "Это текст-руководство для первого уровня. Здесь мы изучаем основы...",
    test: [
      Question(
        question: "Что такое Flutter?",
        answers: ["Фреймворк", "Язык", "База данных", "IDE"],
        correctAnswerIndex: 0,
      ),
      Question(
        question: "На каком языке работает Flutter?",
        answers: ["Java", "Swift", "Dart", "Kotlin"],
        correctAnswerIndex: 2,
      ),
    ],
  ),
  Level(
    id: 2,
    title: "Уровень 2: Виджеты",
    guideText: "На этом уровне мы углубимся в мир виджетов...",
    test: [
      Question(
        question: "Какой виджет используется для создания строки?",
        answers: ["Column", "Row", "Text", "Container"],
        correctAnswerIndex: 1,
      ),
      Question(
        question: "Какой виджет используется для создания кнопки?",
        answers: ["ElevatedButton", "Image", "Icon", "ListView"],
        correctAnswerIndex: 0,
      ),
    ],
  ),
  Level(
    id: 3,
    title: "Уровень 3: Управление состоянием",
    guideText:
        "Здесь мы рассмотрим различные подходы к управлению состоянием...",
    test: [
      Question(
        question: "Какой пакет часто используется для управления состоянием?",
        answers: ["http", "shared_preferences", "provider", "url_launcher"],
        correctAnswerIndex: 2,
      ),
    ],
  ),
];
