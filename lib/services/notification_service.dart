import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../config/app_constants.dart';
import '../models/reminder_setting.dart';
import '../services/storage_service.dart';
import '../services/water_intake_service.dart';
import 'notification_message_service.dart';

/// Bildirim servisi - Local notifications yönetimi
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final NotificationMessageService _messageService =
      NotificationMessageService();
  final StorageService _storageService = StorageService();
  final WaterIntakeService _waterIntakeService = WaterIntakeService();
  bool _initialized = false;

  /// Bildirim servisini başlat
  Future<void> initialize() async {
    if (_initialized) return;

    // Timezone verilerini yükle
    tz.initializeTimeZones();

    // Android ayarları
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS ayarları
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Platform ayarları
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Bildirimleri başlat
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Bildirim tıklandığında çağrılır
  void _onNotificationTapped(NotificationResponse response) {
    // Bildirim tıklandığında yapılacak işlemler
    // Örneğin: Uygulamayı aç, belirli bir ekrana git
  }

  /// Hatırlatma bildirimlerini planla
  Future<void> scheduleReminders(ReminderSetting settings) async {
    if (!_initialized) {
      await initialize();
    }

    // Önce mevcut bildirimleri iptal et
    await cancelAllReminders();

    if (!settings.enabled) return;

    final now = tz.TZDateTime.now(tz.local);
    var startTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.startHour,
      0,
    );

    // Eğer başlangıç saati geçmişse, yarın başlat
    if (startTime.isBefore(now)) {
      startTime = startTime.add(const Duration(days: 1));
    }

    final endTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.endHour,
      0,
    );

    // Her interval dakikada bir bildirim gönder (bugün için)
    int notificationId = AppConstants.reminderNotificationId;
    tz.TZDateTime currentTime = startTime;

    while (currentTime.isBefore(endTime) && currentTime.isAfter(now)) {
      // Kişiselleştirilmiş mesaj oluştur
      final userSettings = await _storageService.loadUserSettings();
      final todaySummary = await _waterIntakeService.getTodaySummary(
        userSettings.dailyGoal,
      );
      
      final personalizedMessage = await _messageService
          .generatePersonalizedMessage(
        todaySummary: todaySummary,
        userSettings: userSettings,
        currentTime: currentTime,
      );
      
      final shortTitle = _messageService.generateShortMessage(
        progress: todaySummary.completionPercentage,
        currentTime: currentTime,
      );

      await _notifications.zonedSchedule(
        notificationId++,
        shortTitle,
        personalizedMessage,
        currentTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'waterly_reminders',
            'Water Reminders',
            channelDescription: 'Regular water drinking reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      currentTime = currentTime.add(
        Duration(minutes: settings.intervalMinutes),
      );
    }
  }

  /// Tüm hatırlatmaları iptal et
  Future<void> cancelAllReminders() async {
    await _notifications.cancel(AppConstants.reminderNotificationId);
    // Birden fazla bildirim varsa, ID aralığını iptal et
    for (int i = AppConstants.reminderNotificationId;
        i < AppConstants.reminderNotificationId + 100;
        i++) {
      await _notifications.cancel(i);
    }
  }

  /// Uyarı bildirimi gönder (uzun süre su içilmediğinde)
  Future<void> showWarningNotification() async {
    if (!_initialized) {
      await initialize();
    }

    // Son içme zamanını kontrol et
    final todayIntakes = await _waterIntakeService.getTodayIntakes();
    int hoursSinceLastIntake = 0;
    
    if (todayIntakes.isEmpty) {
      final now = DateTime.now();
      final morning = DateTime(now.year, now.month, now.day, 9, 0);
      hoursSinceLastIntake = now.difference(morning).inHours;
    } else {
      final lastIntake = todayIntakes.first;
      hoursSinceLastIntake =
          DateTime.now().difference(lastIntake.dateTime).inHours;
    }

    final motivationalMessage = _messageService.generateMotivationalMessage(
      hoursSinceLastIntake: hoursSinceLastIntake,
      currentTime: DateTime.now(),
    );

    await _notifications.show(
      AppConstants.warningNotificationId,
      'Stay Hydrated! 💧',
      motivationalMessage,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'waterly_warnings',
          'Water Warnings',
          channelDescription: 'Warnings shown when water hasn\'t been drunk for a long time',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// Test bildirimi gönder
  Future<void> showTestNotification() async {
    if (!_initialized) {
      await initialize();
    }

    await _notifications.show(
      999,
      'Test Notification',
      'Waterly notifications are working! 🎉',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'waterly_reminders',
          'Water Reminders',
          channelDescription: 'Regular water drinking reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}

