import 'package:flutter/material.dart';
import 'package:learn_game/data/leaderboard_data.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Таблица лидеров')),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final entry = leaderboardData[index];
          final rank = index + 1;
          return ListTile(
            leading: Text(
              '#$rank',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            title: Text(
              entry.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              'Уровней: ${entry.completedLevels}',
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
