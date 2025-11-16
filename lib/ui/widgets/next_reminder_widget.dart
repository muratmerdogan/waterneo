import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/design_system.dart';
import '../../models/reminder_setting.dart';
import '../../utils/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Next Reminder Widget - Bir sonraki bildirim zamanını gösterir
class NextReminderWidget extends ConsumerWidget {
  const NextReminderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderSettings = ref.watch(reminderSettingsProvider);
    
    if (!reminderSettings.enabled) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    final nextReminderTime = _calculateNextReminder(now, reminderSettings);

    if (nextReminderTime == null) {
      return const SizedBox.shrink();
    }

    final timeUntil = nextReminderTime.difference(now);
    final hours = timeUntil.inHours;
    final minutes = timeUntil.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        boxShadow: DesignSystem.lightShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingM),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Reminder',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  hours > 0
                      ? 'In $hours h $minutes m'
                      : 'In $minutes m',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  DateFormat('HH:mm').format(nextReminderTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _calculateNextReminder(DateTime now, ReminderSetting settings) {
    if (!settings.enabled) return null;

    // Bugün için başlangıç zamanı
    var startTime = DateTime(
      now.year,
      now.month,
      now.day,
      settings.startHour,
      0,
    );

    // Bitiş zamanı
    var endTime = DateTime(
      now.year,
      now.month,
      now.day,
      settings.endHour,
      0,
    );

    // Eğer bitiş saati başlangıç saatinden küçükse (örn: 22:00 - 08:00), yarın bitiş demektir
    if (endTime.isBefore(startTime) || endTime == startTime) {
      endTime = endTime.add(const Duration(days: 1));
    }

    // Quiet hours kontrolü
    if (settings.quietHoursEnabled) {
      final quietStart = DateTime(
        now.year,
        now.month,
        now.day,
        settings.quietHoursStart,
        0,
      );
      final quietEnd = DateTime(
        now.year,
        now.month,
        now.day,
        settings.quietHoursEnd,
        0,
      );
      
      // Quiet hours gece yarısını geçiyorsa
      final quietEndAdjusted = quietEnd.isBefore(quietStart) 
          ? quietEnd.add(const Duration(days: 1))
          : quietEnd;
      
      // Şu an quiet hours içindeyse, quiet hours bitene kadar bekle
      if (now.isAfter(quietStart) && now.isBefore(quietEndAdjusted)) {
        startTime = quietEndAdjusted;
        // Eğer quiet hours bitişi bugünün bitiş saatinden sonraysa, yarın başlat
        if (startTime.isAfter(endTime)) {
          startTime = DateTime(
            now.year,
            now.month,
            now.day + 1,
            settings.startHour,
            0,
          );
          endTime = DateTime(
            now.year,
            now.month,
            now.day + 1,
            settings.endHour,
            0,
          );
          if (endTime.isBefore(startTime) || endTime == startTime) {
            endTime = endTime.add(const Duration(days: 1));
          }
        }
      }
    }

    // Eğer başlangıç saati geçmişse, bugün için interval'a göre hesapla
    if (startTime.isBefore(now)) {
      // Şu anki zamandan başlangıç saatine kadar geçen süreyi hesapla
      final minutesSinceStart = now.difference(startTime).inMinutes;
      // Kaç interval geçmiş?
      final intervalsPassed = (minutesSinceStart / settings.intervalMinutes).ceil();
      // Bir sonraki interval zamanını hesapla
      startTime = startTime.add(Duration(minutes: intervalsPassed * settings.intervalMinutes));
    }

    // Eğer hesaplanan zaman bitiş saatinden sonraysa, yarın başlat
    if (startTime.isAfter(endTime) || startTime.isBefore(now)) {
      startTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
        settings.startHour,
        0,
      );
      endTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
        settings.endHour,
        0,
      );
      if (endTime.isBefore(startTime) || endTime == startTime) {
        endTime = endTime.add(const Duration(days: 1));
      }
    }

    // Quiet hours kontrolü (yarın için)
    if (settings.quietHoursEnabled && startTime.day == now.day + 1) {
      final tomorrowQuietStart = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        settings.quietHoursStart,
        0,
      );
      final tomorrowQuietEnd = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        settings.quietHoursEnd,
        0,
      );
      final tomorrowQuietEndAdjusted = tomorrowQuietEnd.isBefore(tomorrowQuietStart)
          ? tomorrowQuietEnd.add(const Duration(days: 1))
          : tomorrowQuietEnd;
      
      // Eğer başlangıç quiet hours içindeyse, quiet hours bitene kadar bekle
      if (startTime.isAfter(tomorrowQuietStart) && startTime.isBefore(tomorrowQuietEndAdjusted)) {
        startTime = tomorrowQuietEndAdjusted;
      }
    }

    return startTime;
  }
}

