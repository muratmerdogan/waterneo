import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_strings.dart';
import '../../models/user_settings.dart' as models;
import '../../utils/providers.dart';
import '../../utils/theme_provider.dart';
import '../../config/design_system.dart';
import '../widgets/modern_card.dart';
import 'reminders_screen.dart';
import 'profile_settings_screen.dart';
import 'premium_screen.dart';
import 'caffeine_tracking_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'firebase_test_screen.dart';

/// Ayarlar ekranı
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        children: [
          // Profile Settings
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Profile Settings'),
              subtitle: Text('Edit personal information'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Premium
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.star_rounded, color: Colors.amber),
              title: const Text('Go Premium'),
              subtitle: const Text('Unlock all features'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Caffeine Tracking (Premium)
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CaffeineTrackingScreen()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.local_cafe_outlined),
              title: const Text('Caffeine Tracking'),
              subtitle: const Text('Track your daily caffeine intake'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(DesignSystem.radiusSmall),
                    ),
                    child: const Text(
                      'PREMIUM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingS),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          // Settings
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          // Günlük hedef
          ModernCard(
            onTap: () => _showGoalDialog(context, userSettings),
            child: ListTile(
              title: const Text(AppStrings.dailyGoal),
              subtitle: Text(
                '${(userSettings.dailyGoal / 1000).toStringAsFixed(1)} L',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Birim seçimi
          ModernCard(
            onTap: () => _showUnitDialog(context, userSettings),
            child: ListTile(
              title: const Text(AppStrings.unit),
              subtitle: Text(userSettings.unitLabel),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Tema
          ModernCard(
            onTap: () => _showThemeDialog(context),
            child: ListTile(
              title: const Text(AppStrings.theme),
              subtitle: Text(_getThemeLabel(themeMode)),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Hatırlatmalar
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RemindersScreen(),
                ),
              );
            },
            child: const ListTile(
              title: Text(AppStrings.reminders),
              subtitle: Text('Edit reminder settings'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          // Legal
          Text(
            'Legal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy Policy'),
              subtitle: Text('How we collect and use your data'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Terms of Service'),
              subtitle: Text('Terms and conditions of use'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          // About
          Text(
            'About',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          ModernCard(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(AppStrings.about),
              subtitle: const Text(AppStrings.aboutDesc),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingS),
          // Firebase Test (Debug)
          ModernCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FirebaseTestScreen()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.cloud, color: Colors.orange),
              title: const Text('Firebase Test'),
              subtitle: const Text('Firebase yapılandırmasını test et'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context, models.UserSettings userSettings) {
    final controller = TextEditingController(
      text: (userSettings.dailyGoal / 1000).toStringAsFixed(1),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.dailyGoal),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Daily goal (L)',
            hintText: 'e.g.: 2.5',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                final goal = (value * 1000).round();
                ref.read(userSettingsProvider.notifier).updateDailyGoal(goal);
                Navigator.of(context).pop();
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  void _showUnitDialog(BuildContext context, models.UserSettings userSettings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.unit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<models.Unit>(
              title: const Text('Milliliters (ml)'),
              value: models.Unit.ml,
              groupValue: userSettings.unit,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateUnit(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<models.Unit>(
              title: const Text('Ounces (oz)'),
              value: models.Unit.oz,
              groupValue: userSettings.unit,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(userSettingsProvider.notifier)
                      .updateUnit(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final currentTheme = ref.read(themeModeProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text(AppStrings.lightTheme),
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text(AppStrings.darkTheme),
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text(AppStrings.systemTheme),
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return AppStrings.lightTheme;
      case ThemeMode.dark:
        return AppStrings.darkTheme;
      case ThemeMode.system:
        return AppStrings.systemTheme;
    }
  }
}

