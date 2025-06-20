import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_game/data/services/leaderboard_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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

              final hasPhone =
                  entry.containsKey('phone') && entry['phone'] != null;

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
                  subtitle: Text('Уровней: ${entry['completedLevels']}'),
                  trailing: hasPhone
                      ? FilledButton.icon(
                          onPressed: () => _showContactDialog(
                            context,
                            entry['name'],
                            entry['phone'],
                          ),
                          icon: const Icon(Symbols.call, size: 18),
                          label: const Text('Связаться'),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showContactDialog(BuildContext context, String name, String phone) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Symbols.monetization_on, size: 32),
        title: Text('Открыть контакты $name?'),
        content: Text(
          'Это действие раскроет вам прямой путь к потенциальному сотруднику. Стоимость — \$5.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessDialog(context, name, phone);
            },
            child: const Text('Купить и показать'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String name, String phone) {
    final theme = Theme.of(context);
    final maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Symbols.task_alt,
          size: 32,
          color: theme.colorScheme.primary,
        ),
        title: const Text('Покупка совершена!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Деньги успешно списаны с вашего баланса. Вот контакты:',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SelectableText(
                  maskFormatter.maskText(phone),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отлично!'),
          ),
        ],
      ),
    );
  }
}
