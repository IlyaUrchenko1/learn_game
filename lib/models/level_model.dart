import 'package:learn_game/models/test_model.dart';

class Level {
  final int id;
  final String title;
  final String guideText;
  final List<Question> test;

  const Level({
    required this.id,
    required this.title,
    required this.guideText,
    required this.test,
  });
}
