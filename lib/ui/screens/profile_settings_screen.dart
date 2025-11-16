import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/design_system.dart';
import '../../models/user_settings.dart';
import '../../utils/providers.dart';
import '../widgets/modern_card.dart';

/// Profile Settings Screen
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(DesignSystem.spacingM),
          children: [
            // Personal Info Section
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            ModernCard(
              onTap: () => _showGenderDialog(context, userSettings),
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Gender'),
                subtitle: Text(
                  userSettings.gender?.toString().split('.').last ?? 'Not set',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingS),
            ModernCard(
              onTap: () => _showWeightDialog(context, userSettings),
              child: ListTile(
                leading: const Icon(Icons.monitor_weight_outlined),
                title: const Text('Weight'),
                subtitle: Text(
                  userSettings.weight != null
                      ? '${userSettings.weight!.toStringAsFixed(1)} kg'
                      : 'Not set',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingS),
            ModernCard(
              onTap: () => _showGoalDialog(context, userSettings),
              child: ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Daily Goal'),
                subtitle: Text(
                  '${(userSettings.dailyGoal / 1000).toStringAsFixed(1)} L',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            // Sleep Schedule
            Text(
              'Sleep Schedule',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            ModernCard(
              onTap: () => _showWakeUpDialog(context, userSettings),
              child: ListTile(
                leading: const Icon(Icons.wb_sunny_outlined),
                title: const Text('Wake Up Time'),
                subtitle: Text(
                  userSettings.wakeUpHour != null
                      ? '${userSettings.wakeUpHour!.toString().padLeft(2, '0')}:00'
                      : 'Not set',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingS),
            ModernCard(
              onTap: () => _showSleepDialog(context, userSettings),
              child: ListTile(
                leading: const Icon(Icons.bedtime_outlined),
                title: const Text('Sleep Time'),
                subtitle: Text(
                  userSettings.sleepHour != null
                      ? '${userSettings.sleepHour!.toString().padLeft(2, '0')}:00'
                      : 'Not set',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            // Activity Level
            Text(
              'Activity Level',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            ModernCard(
              onTap: () => _showActivityDialog(context, userSettings),
              child: ListTile(
                leading: const Icon(Icons.fitness_center_outlined),
                title: const Text('Activity Level'),
                subtitle: Text(
                  userSettings.activityLevel?.toString().split('.').last ?? 'Not set',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            // Data Management
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            ModernCard(
              onTap: () => _showExportDialog(context),
              child: const ListTile(
                leading: Icon(Icons.download_outlined),
                title: Text('Export Data'),
                subtitle: Text('Download your hydration data'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingS),
            ModernCard(
              onTap: () => _showResetDialog(context),
              child: ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Reset All Data',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                subtitle: const Text('This action cannot be undone'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),
            // App Info
            Text(
              'App Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignSystem.spacingM),
            ModernCard(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingXL),
          ],
        ),
      ),
    );
  }

  void _showGenderDialog(BuildContext context, UserSettings userSettings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Gender'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Gender.values.map((gender) {
            return RadioListTile<Gender>(
              title: Text(gender.toString().split('.').last),
              value: gender,
              groupValue: userSettings.gender,
              onChanged: (value) async {
                if (value != null) {
                  await ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(userSettings.copyWith(gender: value));
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showWeightDialog(BuildContext context, UserSettings userSettings) {
    final controller = TextEditingController(
      text: userSettings.weight?.toStringAsFixed(1) ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Weight'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            hintText: 'e.g.: 70.5',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(controller.text);
              if (weight != null && weight > 0) {
                await ref.read(userSettingsProvider.notifier).updateSettings(
                      userSettings.copyWith(weight: weight),
                    );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showGoalDialog(BuildContext context, UserSettings userSettings) {
    final controller = TextEditingController(
      text: (userSettings.dailyGoal / 1000).toStringAsFixed(1),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Goal'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Daily Goal (L)',
            hintText: 'e.g.: 2.5',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                final goal = (value * 1000).round();
                await ref
                    .read(userSettingsProvider.notifier)
                    .updateDailyGoal(goal);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showWakeUpDialog(BuildContext context, UserSettings userSettings) {
    _showTimePickerDialog(
      context,
      'Wake Up Time',
      userSettings.wakeUpHour ?? 7,
      (hour) async {
        await ref.read(userSettingsProvider.notifier).updateSettings(
              userSettings.copyWith(wakeUpHour: hour),
            );
      },
    );
  }

  void _showSleepDialog(BuildContext context, UserSettings userSettings) {
    _showTimePickerDialog(
      context,
      'Sleep Time',
      userSettings.sleepHour ?? 23,
      (hour) async {
        await ref.read(userSettingsProvider.notifier).updateSettings(
              userSettings.copyWith(sleepHour: hour),
            );
      },
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    String title,
    int initialHour,
    Function(int) onSave,
  ) {
    int selectedHour = initialHour;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: 200,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              controller: FixedExtentScrollController(initialItem: initialHour),
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Center(
                    child: Text(
                      '${index.toString().padLeft(2, '0')}:00',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                },
                childCount: 24,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(selectedHour);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showActivityDialog(BuildContext context, UserSettings userSettings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ActivityLevel.values.map((level) {
            return RadioListTile<ActivityLevel>(
              title: Text(level.toString().split('.').last),
              value: level,
              groupValue: userSettings.activityLevel,
              onChanged: (value) async {
                if (value != null) {
                  await ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(userSettings.copyWith(activityLevel: value));
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text(
          'Are you sure you want to delete all your data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement reset data
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reset feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

