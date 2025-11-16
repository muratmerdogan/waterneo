import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/app_strings.dart';
import '../../config/design_system.dart';
import '../../utils/providers.dart';
import '../../services/water_intake_service.dart';
import '../../services/ads_service.dart';
import '../widgets/animated_progress_ring.dart';
import '../widgets/quick_add_buttons.dart';
import '../widgets/daily_tips_widget.dart';
import '../widgets/next_reminder_widget.dart';
import '../widgets/modern_card.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

/// Modern Dashboard Screen - Ana ekran
class ModernDashboardScreen extends ConsumerStatefulWidget {
  const ModernDashboardScreen({super.key});

  @override
  ConsumerState<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends ConsumerState<ModernDashboardScreen>
    with TickerProviderStateMixin {
  final WaterIntakeService _waterIntakeService = WaterIntakeService();
  final AdsService _adsService = AdsService();
  late AnimationController _pulseController;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initializeAds();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _initializeAds() async {
    await _adsService.initialize();
    _bannerAd = _adsService.createBannerAd();
    setState(() {});
  }

  Future<void> _initializeNotifications() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    final reminderSettings = ref.read(reminderSettingsProvider);
    await notificationService.scheduleReminders(reminderSettings);
  }

  Future<void> _addWater(int amount) async {
    await _waterIntakeService.addWaterIntake(amount);
    ref.invalidate(todaySummaryProvider);
    ref.invalidate(streakProvider);
    
    // Interstitial ad göster (her 8 su eklemede bir)
    _adsService.showInterstitialAdOnWaterLog();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: DesignSystem.spacingS),
              Text('$amount ml added! 💧'),
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
  }

  @override
  Widget build(BuildContext context) {
    final todaySummaryAsync = ref.watch(todaySummaryProvider);
    final streakAsync = ref.watch(streakProvider);
    final userSettings = ref.watch(userSettingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Today',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
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

    final displayTotal = userSettings.convertToUnit(totalAmount);
    final displayTarget = userSettings.convertToUnit(targetAmount);
    final unitLabel = userSettings.unitLabel;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: DesignSystem.spacingL),
          // Progress Ring
          AnimatedProgressRing(
            progress: progress,
            size: 220,
            strokeWidth: 14,
            centerChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  '${displayTotal.toStringAsFixed(0)} / ${displayTarget.toStringAsFixed(0)} $unitLabel',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          // Streak Card
          streakAsync.when(
            data: (streak) {
              if (streak > 0) {
                return ModernCard(
                  margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: DesignSystem.spacingS),
                      Text(
                        '$streak ${AppStrings.daysStreak}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          if (streakAsync.valueOrNull != null && streakAsync.valueOrNull! > 0)
            const SizedBox(height: DesignSystem.spacingL),
          // Next Reminder
          const NextReminderWidget(),
          const SizedBox(height: DesignSystem.spacingL),
          // Quick Add Buttons
          QuickAddButtons(onAdd: _addWater),
          const SizedBox(height: DesignSystem.spacingXL),
          // Daily Tips
          const DailyTipsWidget(),
          const SizedBox(height: DesignSystem.spacingXL),
          // Today's History
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
            child: Row(
              children: [
                Text(
                  AppStrings.todayHistory,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          // Intake List
          if (intakes.isEmpty)
            ModernCard(
              margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
              child: Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingXL),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 64,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(height: DesignSystem.spacingM),
                      Text(
                        AppStrings.noRecordsToday,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...intakes.map((intake) {
              final displayAmount = userSettings.convertToUnit(intake.amount);
              return ModernCard(
                margin: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingM,
                  vertical: DesignSystem.spacingXS,
                ),
                onTap: () async {
                  await _waterIntakeService.deleteWaterIntake(intake);
                  ref.invalidate(todaySummaryProvider);
                  ref.invalidate(streakProvider);
                },
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(DesignSystem.spacingS),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(DesignSystem.radiusSmall),
                    ),
                    child: Icon(
                      Icons.water_drop,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${displayAmount.toStringAsFixed(0)} $unitLabel',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('HH:mm').format(intake.dateTime),
                  ),
                  trailing: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              );
            }).toList(),
          const SizedBox(height: DesignSystem.spacingXL),
          // Banner Ad (if not premium)
          if (_bannerAd != null)
            Container(
              margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}

