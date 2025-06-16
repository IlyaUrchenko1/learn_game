import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_game/data/services/leaderboard_service.dart';
import 'package:material_symbols_icons/symbols.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Таблица лидеров')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _leaderboardService.getLeaderboardStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Пока никто не прошел ни одного уровня.\nБудь первым!',
                textAlign: TextAlign.center,
              ),
            );
          }

          final leaderboardDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaderboardDocs.length,
            itemBuilder: (context, index) {
              final entry =
                  leaderboardDocs[index].data() as Map<String, dynamic>;
              final rank = index + 1;

              Widget leading;
              if (rank <= 3) {
                Color trophyColor;
                switch (rank) {
                  case 1:
                    trophyColor = const Color(0xFFFFD700); // Gold
                    break;
                  case 2:
                    trophyColor = const Color(0xFFC0C0C0); // Silver
                    break;
                  case 3:
                    trophyColor = const Color(0xFFCD7F32); // Bronze
                    break;
                  default:
                    trophyColor = theme.colorScheme.onSurface;
                }
                leading = Icon(
                  Symbols.trophy_rounded,
                  color: trophyColor,
                  fill: 1,
                );
              } else {
                leading = Text(
                  '#$rank',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: leading,
                  title: Text(
                    entry['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    'Уровней: ${entry['completedLevels']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
