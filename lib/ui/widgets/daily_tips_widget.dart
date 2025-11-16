import 'package:flutter/material.dart';
import '../../config/design_system.dart';

/// Daily Tips Widget - Motivasyonel ipuçları
class DailyTipsWidget extends StatelessWidget {
  const DailyTipsWidget({super.key});

  static final List<String> _tips = [
    '💧 Start your day with a glass of water to kickstart your metabolism',
    '🌅 Keep a water bottle nearby to remind yourself to drink regularly',
    '⏰ Set reminders every 2 hours for consistent hydration',
    '🍋 Add lemon or cucumber for a refreshing twist',
    '📊 Track your intake to build healthy habits',
    '🚰 Room temperature water is absorbed faster than cold water',
    '💪 Stay hydrated during workouts for better performance',
    '😴 Drink water before bed, but not too much to avoid disruptions',
  ];

  @override
  Widget build(BuildContext context) {
    final tip = _tips[DateTime.now().day % _tips.length];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

