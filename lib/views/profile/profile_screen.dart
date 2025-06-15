import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat(
      'd MMMM yyyy',
      'ru_RU',
    ).format(DateTime.now());
    const int totalLevels = 10; // Placeholder for total number of levels

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль'), centerTitle: true),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          final completedCount = progressProvider.completedLevels.length;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(context, currentDate),
              const SizedBox(height: 24),
              _buildProgressCard(context, completedCount, totalLevels),
              const SizedBox(height: 24),
              _buildActionsCard(context),
              const SizedBox(height: 24),
              _buildDangerZone(context, progressProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String currentDate) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          'Привет, Игрок!',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Сегодня: $currentDate',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    int completedCount,
    int totalLevels,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ваш прогресс',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ты прошёл $completedCount из $totalLevels уровней',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.rate_review_outlined, color: Colors.blue),
            title: const Text('Оценить приложение'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // ignore: avoid_print
              print('User wants to rate the app.');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Спасибо за вашу оценку! (симуляция)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined, color: Colors.green),
            title: const Text('Сообщить об ошибке'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // ignore: avoid_print
              print('User wants to report a bug.');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Отправка отчета об ошибке... (симуляция)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(
    BuildContext context,
    ProgressProvider progressProvider,
  ) {
    return Card(
      elevation: 4,
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
        title: const Text('Сбросить прогресс'),
        subtitle: const Text('Это действие нельзя будет отменить'),
        onTap: () {
          progressProvider.resetProgress();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Прогресс сброшен!'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
