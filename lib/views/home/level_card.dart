import 'package:flutter/material.dart';
import 'package:learn_game/models/level_model.dart';

class LevelCard extends StatelessWidget {
  final Level level;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.isCompleted,
    required this.isLocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isLocked ? 0 : 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  isLocked
                      ? Icons.lock_outline
                      : isCompleted
                      ? Icons.check_circle_outline
                      : Icons.play_circle_outline,
                  color: isLocked
                      ? Colors.grey
                      : isCompleted
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    level.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
