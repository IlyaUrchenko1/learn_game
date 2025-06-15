import 'package:flutter/material.dart';
import 'package:learn_game/models/level_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class LevelNode extends StatelessWidget {
  final Level level;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  const LevelNode({
    super.key,
    required this.level,
    required this.isCompleted,
    required this.isLocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    IconData icon;
    Color? iconColor = theme.colorScheme.onPrimary;

    if (isLocked) {
      color = Colors.grey.shade600;
      icon = Symbols.lock;
      iconColor = Colors.white70;
    } else if (isCompleted) {
      color = theme.colorScheme.primary;
      icon = Symbols.check;
    } else {
      color = theme.colorScheme.secondary;
      icon = Symbols.play_arrow;
    }

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Tooltip(
        message: level.title,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(icon, color: iconColor, size: 30),
        ),
      ),
    );
  }
}
