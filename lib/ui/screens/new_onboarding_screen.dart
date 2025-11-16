import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/design_system.dart';
import '../../models/user_settings.dart';
import '../../utils/providers.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_button.dart';
import 'dashboard_screen.dart';

/// Modern 4-Step Onboarding Flow
class NewOnboardingScreen extends ConsumerStatefulWidget {
  const NewOnboardingScreen({super.key});

  @override
  ConsumerState<NewOnboardingScreen> createState() => _NewOnboardingScreenState();
}

class _NewOnboardingScreenState extends ConsumerState<NewOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form data
  Gender? _selectedGender;
  double? _weight;
  int _wakeUpHour = 7;
  int _sleepHour = 23;
  ActivityLevel? _activityLevel;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: DesignSystem.animationMedium,
        curve: DesignSystem.defaultCurve,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: DesignSystem.animationMedium,
        curve: DesignSystem.defaultCurve,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_weight == null || _activityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // Calculate daily goal
    final dailyGoal = UserSettings.calculateDailyGoal(
      weight: _weight!,
      activityLevel: _activityLevel!,
    );

    // Save settings
    final userSettings = ref.read(userSettingsProvider);
    await ref.read(userSettingsProvider.notifier).updateSettings(
          userSettings.copyWith(
            gender: _selectedGender,
            weight: _weight,
            wakeUpHour: _wakeUpHour,
            sleepHour: _sleepHour,
            activityLevel: _activityLevel,
            dailyGoal: dailyGoal,
            onboardingCompleted: true,
          ),
        );

    // Initialize notifications with wake/sleep hours
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();
    final reminderSettings = ref.read(reminderSettingsProvider);
    await ref.read(reminderSettingsProvider.notifier).updateSettings(
          reminderSettings.copyWith(
            startHour: _wakeUpHour,
            endHour: _sleepHour,
          ),
        );
    await notificationService.scheduleReminders(
      reminderSettings.copyWith(
        startHour: _wakeUpHour,
        endHour: _sleepHour,
      ),
    );

    // Navigate to dashboard
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
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildGenderPage(),
                  _buildWeightPage(),
                  _buildSleepPage(),
                  _buildActivityPage(),
                ],
              ),
            ),
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < 3 ? DesignSystem.spacingS : 0,
              ),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGenderPage() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 80,
            color: DesignSystem.primaryTurquoise,
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'What\'s your gender?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            'This helps us personalize your hydration goals',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  gender: Gender.male,
                  icon: Icons.male,
                  label: 'Male',
                ),
              ),
              const SizedBox(width: DesignSystem.spacingM),
              Expanded(
                child: _buildGenderOption(
                  gender: Gender.female,
                  icon: Icons.female,
                  label: 'Female',
                ),
              ),
              const SizedBox(width: DesignSystem.spacingM),
              Expanded(
                child: _buildGenderOption(
                  gender: Gender.other,
                  icon: Icons.person,
                  label: 'Other',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption({
    required Gender gender,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: DesignSystem.animationMedium,
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: DesignSystem.spacingS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.monitor_weight_outlined,
            size: 80,
            color: DesignSystem.primaryTurquoise,
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'What\'s your weight?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            'We use this to calculate your optimal daily water intake',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          ModernCard(
            padding: const EdgeInsets.all(DesignSystem.spacingXL),
            child: Column(
              children: [
                Text(
                  _weight != null ? '${_weight!.toStringAsFixed(1)} kg' : '-- kg',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: DesignSystem.spacingXL),
                Slider(
                  value: _weight ?? 70.0,
                  min: 30.0,
                  max: 150.0,
                  divisions: 240,
                  label: _weight != null ? '${_weight!.toStringAsFixed(1)} kg' : null,
                  onChanged: (value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                const SizedBox(height: DesignSystem.spacingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [50, 60, 70, 80, 90].map((weight) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _weight = weight.toDouble();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignSystem.spacingM,
                          vertical: DesignSystem.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: _weight == weight
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
                        ),
                        child: Text(
                          '$weight kg',
                          style: TextStyle(
                            color: _weight == weight
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: _weight == weight
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepPage() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bedtime_outlined,
            size: 80,
            color: DesignSystem.primaryTurquoise,
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'When do you wake up and sleep?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            'We\'ll adjust reminders to your schedule',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          Row(
            children: [
              Expanded(
                child: ModernCard(
                  child: Column(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, size: 40),
                      const SizedBox(height: DesignSystem.spacingM),
                      Text(
                        'Wake Up',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: DesignSystem.spacingL),
                      Text(
                        '${_wakeUpHour.toString().padLeft(2, '0')}:00',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: DesignSystem.spacingM),
                      SizedBox(
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          controller: FixedExtentScrollController(
                            initialItem: _wakeUpHour,
                          ),
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _wakeUpHour = index;
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
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignSystem.spacingM),
              Expanded(
                child: ModernCard(
                  child: Column(
                    children: [
                      const Icon(Icons.bedtime, size: 40),
                      const SizedBox(height: DesignSystem.spacingM),
                      Text(
                        'Sleep',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: DesignSystem.spacingL),
                      Text(
                        '${_sleepHour.toString().padLeft(2, '0')}:00',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: DesignSystem.spacingM),
                      SizedBox(
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 50,
                          controller: FixedExtentScrollController(
                            initialItem: _sleepHour,
                          ),
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _sleepHour = index;
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityPage() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center_outlined,
            size: 80,
            color: DesignSystem.primaryTurquoise,
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Text(
            'How active are you?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            'This affects your daily water needs',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingXXL),
          Column(
            children: [
              _buildActivityOption(
                level: ActivityLevel.low,
                icon: Icons.sentiment_satisfied_alt,
                title: 'Low Activity',
                description: 'Mostly sedentary, light walking',
                color: DesignSystem.pastelBlue,
              ),
              const SizedBox(height: DesignSystem.spacingM),
              _buildActivityOption(
                level: ActivityLevel.normal,
                icon: Icons.directions_walk,
                title: 'Normal Activity',
                description: 'Regular exercise, active lifestyle',
                color: DesignSystem.pastelTurquoise,
              ),
              const SizedBox(height: DesignSystem.spacingM),
              _buildActivityOption(
                level: ActivityLevel.intense,
                icon: Icons.sports_gymnastics,
                title: 'Intense Activity',
                description: 'Heavy workouts, athlete',
                color: DesignSystem.pastelCyan,
              ),
            ],
          ),
          if (_weight != null && _activityLevel != null) ...[
            const SizedBox(height: DesignSystem.spacingXL),
            ModernCard(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Column(
                children: [
                  Text(
                    'Your Daily Goal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: DesignSystem.spacingS),
                  Text(
                    '${UserSettings.calculateDailyGoal(weight: _weight!, activityLevel: _activityLevel!) ~/ 100}00 ml',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityOption({
    required ActivityLevel level,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isSelected = _activityLevel == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activityLevel = level;
        });
      },
      child: AnimatedContainer(
        duration: DesignSystem.animationMedium,
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.3)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(width: DesignSystem.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: ModernButton(
                text: 'Back',
                isOutlined: true,
                onPressed: _previousPage,
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: ModernButton(
              text: _currentPage < 3 ? 'Next' : 'Get Started',
              isPrimary: true,
              onPressed: () {
                if (_currentPage == 0 && _selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select your gender')),
                  );
                  return;
                }
                if (_currentPage == 1 && _weight == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please set your weight')),
                  );
                  return;
                }
                if (_currentPage == 3 && _activityLevel == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select activity level')),
                  );
                  return;
                }
                _nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}

