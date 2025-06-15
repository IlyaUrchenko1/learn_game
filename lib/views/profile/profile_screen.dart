import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_game/data/levels_data.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final String currentDate = DateFormat(
      'd MMMM yyyy',
      'ru_RU',
    ).format(DateTime.now());
    final totalLevels = allLevels.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль'), centerTitle: true),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          final completedCount = progressProvider.completedLevels.length;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(context, 'Игрок', currentDate),
              const SizedBox(height: 24),
              _buildProgressCard(context, completedCount, totalLevels),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Обратная связь'),
              _buildActionsCard(context),
              const SizedBox(height: 24),
              _buildDangerZone(context, progressProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String registrationDate,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Symbols.account_circle,
            size: 60,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Привет, $name!',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'В игре с $registrationDate',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    int completedCount,
    int totalLevels,
  ) {
    final theme = Theme.of(context);
    final progress = totalLevels > 0 ? completedCount / totalLevels : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ваш прогресс', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Symbols.star, color: theme.colorScheme.tertiary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Пройдено $completedCount из $totalLevels уровней',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Symbols.rate_review),
            title: const Text('Оценить приложение'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Symbols.bug_report),
            title: const Text('Сообщить об ошибке'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(
    BuildContext context,
    ProgressProvider progressProvider,
  ) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.warning,
                  color: theme.colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  'Опасная зона',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Сброс вашего прогресса приведет к окончательной потере всех ваших достижений. Это действие нельзя отменить.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                progressProvider.resetProgress();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Прогресс сброшен!'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: const Text('Сбросить мой прогресс'),
            ),
          ],
        ),
      ),
    );
  }
}
