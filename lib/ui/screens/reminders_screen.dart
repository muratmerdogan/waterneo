import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_strings.dart';
import '../../config/design_system.dart';
import '../../utils/providers.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_button.dart';

/// Hatırlatmalar ekranı
class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    final reminderSettings = ref.watch(reminderSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reminders),
      ),
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        children: [
          // Reminders Enabled
          ModernCard(
            child: SwitchListTile(
              title: const Text(AppStrings.reminderEnabled),
              subtitle: const Text('Receive regular reminders'),
              value: reminderSettings.enabled,
              onChanged: (value) async {
                final newSettings = reminderSettings.copyWith(enabled: value);
                await ref
                    .read(reminderSettingsProvider.notifier)
                    .updateSettings(newSettings);
                final notificationService =
                    ref.read(notificationServiceProvider);
                await notificationService.scheduleReminders(newSettings);
              },
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Smart Notifications
          ModernCard(
            child: SwitchListTile(
              title: const Text('Smart Notifications'),
              subtitle: const Text('Personalized messages based on your progress'),
              value: reminderSettings.smartNotifications,
              onChanged: (value) async {
                final newSettings = reminderSettings.copyWith(smartNotifications: value);
                await ref
                    .read(reminderSettingsProvider.notifier)
                    .updateSettings(newSettings);
                final notificationService =
                    ref.read(notificationServiceProvider);
                await notificationService.scheduleReminders(newSettings);
              },
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'Schedule',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          // Reminder Interval
          ModernCard(
            onTap: () => _showIntervalDialog(context, reminderSettings),
            child: ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text(AppStrings.reminderInterval),
              subtitle: Text('${reminderSettings.intervalMinutes} ${AppStrings.minutes}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Start Time
          ModernCard(
            onTap: () => _showTimeDialog(context, reminderSettings, true),
            child: ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: const Text(AppStrings.reminderStartTime),
              subtitle: Text('${reminderSettings.startHour.toString().padLeft(2, '0')}:00'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // End Time
          ModernCard(
            onTap: () => _showTimeDialog(context, reminderSettings, false),
            child: ListTile(
              leading: const Icon(Icons.bedtime_outlined),
              title: const Text(AppStrings.reminderEndTime),
              subtitle: Text('${reminderSettings.endHour.toString().padLeft(2, '0')}:00'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'Quiet Hours',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          ModernCard(
            child: SwitchListTile(
              title: const Text('Enable Quiet Hours'),
              subtitle: Text(
                'No notifications between ${reminderSettings.quietHoursStart.toString().padLeft(2, '0')}:00 - ${reminderSettings.quietHoursEnd.toString().padLeft(2, '0')}:00',
              ),
              value: reminderSettings.quietHoursEnabled,
              onChanged: (value) async {
                final newSettings = reminderSettings.copyWith(quietHoursEnabled: value);
                await ref
                    .read(reminderSettingsProvider.notifier)
                    .updateSettings(newSettings);
                final notificationService =
                    ref.read(notificationServiceProvider);
                await notificationService.scheduleReminders(newSettings);
              },
            ),
          ),
          if (reminderSettings.quietHoursEnabled) ...[
            const SizedBox(height: DesignSystem.spacingS),
            ModernCard(
              onTap: () => _showQuietHoursDialog(context, reminderSettings),
              child: ListTile(
                leading: const Icon(Icons.nightlight_outlined),
                title: const Text('Quiet Hours Time'),
                subtitle: Text(
                  '${reminderSettings.quietHoursStart.toString().padLeft(2, '0')}:00 - ${reminderSettings.quietHoursEnd.toString().padLeft(2, '0')}:00',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'Notification Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          ModernCard(
            child: SwitchListTile(
              title: const Text('Sound'),
              subtitle: const Text('Play sound with notifications'),
              value: reminderSettings.soundEnabled,
              onChanged: (value) async {
                final newSettings = reminderSettings.copyWith(soundEnabled: value);
                await ref
                    .read(reminderSettingsProvider.notifier)
                    .updateSettings(newSettings);
              },
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          ModernCard(
            child: SwitchListTile(
              title: const Text('Vibration'),
              subtitle: const Text('Vibrate with notifications'),
              value: reminderSettings.vibrationEnabled,
              onChanged: (value) async {
                final newSettings = reminderSettings.copyWith(vibrationEnabled: value);
                await ref
                    .read(reminderSettingsProvider.notifier)
                    .updateSettings(newSettings);
              },
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'Message',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          ModernCard(
            onTap: () => _showMessageDialog(context, reminderSettings),
            child: ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text(AppStrings.reminderMessage),
              subtitle: Text(reminderSettings.message),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          // Test Notification Button
          ModernButton(
            text: 'Send Test Notification',
            icon: Icons.notifications_outlined,
            isPrimary: true,
            onPressed: () async {
              final notificationService = ref.read(notificationServiceProvider);
              await notificationService.showTestNotification();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: DesignSystem.spacingS),
                        Text('Test notification sent!'),
                      ],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: DesignSystem.spacingXL),
        ],
        ),
      ),
    );
  }

  void _showIntervalDialog(
      BuildContext context, dynamic reminderSettings) {
    final intervals = [30, 60, 90, 120, 150, 180];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.reminderInterval),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: intervals.map((interval) {
            return RadioListTile<int>(
              title: Text('$interval ${AppStrings.minutes}'),
              value: interval,
              groupValue: reminderSettings.intervalMinutes,
              onChanged: (value) async {
                if (value != null) {
                  final newSettings =
                      reminderSettings.copyWith(intervalMinutes: value);
                  await ref
                      .read(reminderSettingsProvider.notifier)
                      .updateSettings(newSettings);
                  final notificationService =
                      ref.read(notificationServiceProvider);
                  await notificationService.scheduleReminders(newSettings);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTimeDialog(
      BuildContext context, dynamic reminderSettings, bool isStartTime) {
    final hours = List.generate(24, (i) => i);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isStartTime
            ? AppStrings.reminderStartTime
            : AppStrings.reminderEndTime),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: hours.length,
            itemBuilder: (context, index) {
              final hour = hours[index];
              final currentHour =
                  isStartTime ? reminderSettings.startHour : reminderSettings.endHour;
              return RadioListTile<int>(
                title: Text('$hour:00'),
                value: hour,
                groupValue: currentHour,
                onChanged: (value) async {
                  if (value != null) {
                    final newSettings = isStartTime
                        ? reminderSettings.copyWith(startHour: value)
                        : reminderSettings.copyWith(endHour: value);
                    await ref
                        .read(reminderSettingsProvider.notifier)
                        .updateSettings(newSettings);
                    final notificationService =
                        ref.read(notificationServiceProvider);
                    await notificationService.scheduleReminders(newSettings);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(
      BuildContext context, dynamic reminderSettings) {
    final controller =
        TextEditingController(text: reminderSettings.message);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.reminderMessage),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Your notification message',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final newSettings =
                  reminderSettings.copyWith(message: controller.text);
              await ref
                  .read(reminderSettingsProvider.notifier)
                  .updateSettings(newSettings);
              final notificationService = ref.read(notificationServiceProvider);
              await notificationService.scheduleReminders(newSettings);
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  void _showQuietHoursDialog(BuildContext context, dynamic reminderSettings) {
    int startHour = reminderSettings.quietHoursStart;
    int endHour = reminderSettings.quietHoursEnd;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Quiet Hours'),
          content: SizedBox(
            height: 300,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Start'),
                      const SizedBox(height: DesignSystem.spacingS),
                      SizedBox(
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          controller: FixedExtentScrollController(initialItem: startHour),
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              startHour = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  '${index.toString().padLeft(2, '0')}:00',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            },
                            childCount: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DesignSystem.spacingM),
                Expanded(
                  child: Column(
                    children: [
                      const Text('End'),
                      const SizedBox(height: DesignSystem.spacingS),
                      SizedBox(
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          controller: FixedExtentScrollController(initialItem: endHour),
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              endHour = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Center(
                                child: Text(
                                  '${index.toString().padLeft(2, '0')}:00',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            },
                            childCount: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newSettings = reminderSettings.copyWith(
                  quietHoursStart: startHour,
                  quietHoursEnd: endHour,
                );
                await ref
                    .read(reminderSettingsProvider.notifier)
                    .updateSettings(newSettings);
                final notificationService =
                    ref.read(notificationServiceProvider);
                await notificationService.scheduleReminders(newSettings);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

