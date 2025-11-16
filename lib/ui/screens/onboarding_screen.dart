import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_strings.dart';
import '../../config/app_constants.dart';
import '../../utils/providers.dart';
import '../widgets/onboarding_page.dart';
import 'dashboard_screen.dart';

/// Onboarding ekranı - Kullanıcıyı uygulamaya tanıtır ve ilk ayarları yapar
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form değerleri
  int _dailyGoal = AppConstants.defaultDailyGoal;
  int _reminderInterval = AppConstants.defaultReminderInterval;
  int _startHour = AppConstants.defaultStartHour;
  int _endHour = AppConstants.defaultEndHour;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Ayarları kaydet
    final userSettings = ref.read(userSettingsProvider);
    await ref.read(userSettingsProvider.notifier).updateSettings(
          userSettings.copyWith(
            dailyGoal: _dailyGoal,
            onboardingCompleted: true,
          ),
        );

    final reminderSettings = ref.read(reminderSettingsProvider);
    await ref.read(reminderSettingsProvider.notifier).updateSettings(
          reminderSettings.copyWith(
            intervalMinutes: _reminderInterval,
            startHour: _startHour,
            endHour: _endHour,
          ),
        );

    // Bildirimleri planla
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    await notificationService.scheduleReminders(
      reminderSettings.copyWith(
        intervalMinutes: _reminderInterval,
        startHour: _startHour,
        endHour: _endHour,
      ),
    );

    // Dashboard'a git
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // Sayfa 1: Hoş geldiniz
          OnboardingPage(
            title: AppStrings.onboardingWelcome,
            description: AppStrings.onboardingWelcomeDesc,
            imageEmoji: '💧',
            onNext: _nextPage,
            onSkip: _skipOnboarding,
          ),
          // Sayfa 2: Günlük hedef
          OnboardingPage(
            title: AppStrings.onboardingSetGoal,
            description: AppStrings.onboardingSetGoalDesc,
            imageEmoji: '🎯',
            onNext: _nextPage,
            onSkip: _skipOnboarding,
            content: _buildGoalSelector(),
          ),
          // Sayfa 3: Hatırlatmalar
          OnboardingPage(
            title: AppStrings.onboardingSetReminder,
            description: AppStrings.onboardingSetReminderDesc,
            imageEmoji: '🔔',
            onNext: _completeOnboarding,
            content: _buildReminderSelector(),
          ),
        ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: _buildPageIndicator(),
      ),
    );
  }

  Widget _buildGoalSelector() {
    final goals = [2000, 2500, 3000, 3500, 4000];
    return Column(
      children: [
        Text(
          '${(_dailyGoal / 1000).toStringAsFixed(1)} L',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 24),
        Slider(
          value: _dailyGoal.toDouble(),
          min: 1500,
          max: 5000,
          divisions: 35,
          label: '${(_dailyGoal / 1000).toStringAsFixed(1)} L',
          onChanged: (value) {
            setState(() {
              _dailyGoal = value.round();
            });
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: goals.map((goal) {
            final isSelected = _dailyGoal == goal;
            return ChoiceChip(
              label: Text('${(goal / 1000).toStringAsFixed(1)} L'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _dailyGoal = goal;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReminderSelector() {
    final intervals = [60, 90, 120, 150, 180];
    return Column(
      children: [
        Text(
          '$_reminderInterval ${AppStrings.minutes}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 24),
        Slider(
          value: _reminderInterval.toDouble(),
          min: 30,
          max: 240,
          divisions: 42,
          label: '$_reminderInterval ${AppStrings.minutes}',
          onChanged: (value) {
            setState(() {
              _reminderInterval = value.round();
            });
          },
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: intervals.map((interval) {
            final isSelected = _reminderInterval == interval;
            return ChoiceChip(
              label: Text('$interval ${AppStrings.minutes}'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _reminderInterval = interval;
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  AppStrings.reminderStartTime,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: _startHour,
                  items: List.generate(12, (i) => i + 6).map((hour) {
                    return DropdownMenuItem(
                      value: hour,
                      child: Text('$hour:00'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _startHour = value;
                      });
                    }
                  },
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  AppStrings.reminderEndTime,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: _endHour,
                  items: List.generate(12, (i) => i + 12).map((hour) {
                    return DropdownMenuItem(
                      value: hour,
                      child: Text('$hour:00'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _endHour = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }
}

