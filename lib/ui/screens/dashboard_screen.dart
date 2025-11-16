import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/app_strings.dart';
import '../../config/app_constants.dart';
import '../../utils/providers.dart';
import '../../services/water_intake_service.dart';
import '../widgets/progress_ring.dart';
import '../widgets/quick_add_buttons.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

/// Dashboard (Ana Ekran) - Kullanıcının günlük su içme durumunu gösterir
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final WaterIntakeService _waterIntakeService = WaterIntakeService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    final reminderSettings = ref.read(reminderSettingsProvider);
    await notificationService.scheduleReminders(reminderSettings);
  }

  Future<void> _addWater(int amount) async {
    await _waterIntakeService.addWaterIntake(amount);
    // Provider'ı yenile
    ref.invalidate(todaySummaryProvider);
    ref.invalidate(streakProvider);
    
    // Başarı animasyonu göster
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$amount ml water added! 💧'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todaySummaryAsync = ref.watch(todaySummaryProvider);
    final streakAsync = ref.watch(streakProvider);
    final userSettings = ref.watch(userSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.today),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todaySummaryProvider);
          ref.invalidate(streakProvider);
        },
        child: todaySummaryAsync.when(
          data: (summary) => _buildContent(summary, streakAsync, userSettings),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildContent(
    dynamic summary,
    AsyncValue<int> streakAsync,
    dynamic userSettings,
  ) {
    final progress = summary.completionPercentage;
    final totalAmount = summary.totalAmount;
    final targetAmount = summary.targetAmount;
    final intakes = summary.intakes;

    // Birim dönüşümü
    final displayTotal = userSettings.convertToUnit(totalAmount);
    final displayTarget = userSettings.convertToUnit(targetAmount);
    final unitLabel = userSettings.unitLabel;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Progress Ring
          ProgressRing(
            progress: progress,
            size: AppConstants.progressIndicatorSize,
            strokeWidth: AppConstants.progressStrokeWidth,
            centerChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${displayTotal.toStringAsFixed(1)} / ${displayTarget.toStringAsFixed(1)} $unitLabel',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Streak bilgisi
          streakAsync.when(
            data: (streak) {
              if (streak > 0) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔥'),
                        const SizedBox(width: 8),
                        Text(
                          '$streak ${AppStrings.daysStreak}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          // Quick Add Buttons
          QuickAddButtons(onAdd: _addWater),
          const SizedBox(height: 32),
          // Uyarı kartı (eğer hedefin altındaysa)
          if (!summary.isTargetReached && totalAmount < targetAmount * 0.5)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.warningLowIntake,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.warningLowIntakeDesc,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          // Bugünkü kayıtlar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  AppStrings.todayHistory,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Kayıt listesi
          if (intakes.isEmpty)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    AppStrings.noRecordsToday,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: intakes.length,
              itemBuilder: (context, index) {
                final intake = intakes[index];
                final displayAmount =
                    userSettings.convertToUnit(intake.amount);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.water_drop, color: Colors.blue),
                    title: Text(
                      '${displayAmount.toStringAsFixed(0)} $unitLabel',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('HH:mm').format(intake.dateTime),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        await _waterIntakeService.deleteWaterIntake(intake);
                        ref.invalidate(todaySummaryProvider);
                        ref.invalidate(streakProvider);
                      },
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

