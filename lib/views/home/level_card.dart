import 'package:flutter/material.dart';
import 'package:learn_game/core/theme/app_colors.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:material_symbols_icons/symbols.dart';

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
    final theme = Theme.of(context);
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
                      ? Symbols.lock_rounded
                      : isCompleted
                      ? Symbols.check_circle_rounded
                      : Symbols.play_circle_rounded,
                  fill: isCompleted ? 1 : 0,
                  color: isLocked
                      ? theme.colorScheme.onSurface.withOpacity(0.5)
                      : isCompleted
                      ? theme.colorScheme.success
                      : theme.colorScheme.primary,
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
