import 'package:flutter/material.dart';
import 'package:learn_game/data/levels_data.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:learn_game/views/game/guide_screen.dart';
import 'package:learn_game/views/home/level_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уровни'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Temp button to test progress
              Provider.of<ProgressProvider>(
                context,
                listen: false,
              ).resetProgress();
            },
          ),
        ],
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          return ListView.builder(
            itemCount: allLevels.length,
            itemBuilder: (context, index) {
              final level = allLevels[index];
              final isCompleted = progressProvider.isCompleted(level.id);
              // A level is locked if it's not the first one and the previous one is not completed.
              final isLocked =
                  index > 0 &&
                  !progressProvider.isCompleted(allLevels[index - 1].id);

              return LevelCard(
                level: level,
                isCompleted: isCompleted,
                isLocked: isLocked,
                onTap: () {
                  if (!isLocked) {
                    Navigator.pushNamed(
                      context,
                      GuideScreen.routeName,
                      arguments: level,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
