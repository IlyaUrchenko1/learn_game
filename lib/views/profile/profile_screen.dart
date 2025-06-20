import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_game/data/levels_data.dart';
import 'package:learn_game/data/services/leaderboard_service.dart';
import 'package:learn_game/providers/name_provider.dart';
import 'package:learn_game/providers/progress_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  String? _currentPhoneNumber;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final nameProvider = Provider.of<NameProvider>(context, listen: false);
    final phoneNumber = await _leaderboardService.getPhoneNumber(
      nameProvider.name,
    );
    if (mounted) {
      setState(() {
        _currentPhoneNumber = phoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat(
      'd MMMM yyyy',
      'ru_RU',
    ).format(DateTime.now());
    final totalLevels = allLevels.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль'), centerTitle: true),
      body: Consumer2<ProgressProvider, NameProvider>(
        builder: (context, progressProvider, nameProvider, child) {
          final completedCount = progressProvider.completedLevels.length;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(
                context,
                nameProvider.name,
                currentDate,
                () => _showEditNameDialog(context, nameProvider),
              ),
              const SizedBox(height: 24),
              _buildProgressCard(context, completedCount, totalLevels),
              const SizedBox(height: 24),
              _buildVisibilityCard(
                context,
                nameProvider,
                () => _showEditPhoneDialog(context, nameProvider),
              ),
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

  Future<void> _showEditNameDialog(
    BuildContext context,
    NameProvider nameProvider,
  ) async {
    final nameController = TextEditingController(text: nameProvider.name);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Изменить имя'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Введите ваше имя'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  nameProvider.saveName(newName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditPhoneDialog(
    BuildContext context,
    NameProvider nameProvider,
  ) async {
    final phoneController = TextEditingController(text: _currentPhoneNumber);
    final maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Изменить номер телефона'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '+7 (999) 999-99-99',
              border: OutlineInputBorder(),
              filled: true,
            ),
            inputFormatters: [maskFormatter],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () async {
                final newPhone = maskFormatter.getUnmaskedText();
                await _leaderboardService.updateUserPhone(
                  nameProvider.name,
                  newPhone.isNotEmpty ? newPhone : null,
                );
                if (mounted) {
                  setState(() {
                    _currentPhoneNumber = newPhone.isNotEmpty ? newPhone : null;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Номер телефона обновлен!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String registrationDate,
    VoidCallback onEdit,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Привет, $name!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Symbols.edit, size: 20),
              onPressed: onEdit,
            ),
          ],
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

  Widget _buildVisibilityCard(
    BuildContext context,
    NameProvider nameProvider,
    VoidCallback onEdit,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Станьте заметным', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Добавьте свой номер, чтобы лучшие IT-компании и стартапы могли связаться с вами и предложить работу мечты. Ваш контакт увидят только после символической оплаты.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Symbols.call),
              title: Text(_currentPhoneNumber ?? 'Номер не указан'),
              trailing: const Icon(Symbols.edit),
              onTap: onEdit,
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
