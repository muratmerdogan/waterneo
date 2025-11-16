import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/design_system.dart';
import '../../models/caffeine_intake.dart';
import '../../services/caffeine_service.dart';
import '../../services/premium_service.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_button.dart';
import 'premium_screen.dart';

/// Caffeine Tracking Screen (Premium Feature)
class CaffeineTrackingScreen extends ConsumerStatefulWidget {
  const CaffeineTrackingScreen({super.key});

  @override
  ConsumerState<CaffeineTrackingScreen> createState() => _CaffeineTrackingScreenState();
}

class _CaffeineTrackingScreenState extends ConsumerState<CaffeineTrackingScreen> {
  final CaffeineService _caffeineService = CaffeineService();
  final PremiumService _premiumService = PremiumService();
  bool _isPremium = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final status = await _premiumService.checkPremiumStatus();
    setState(() {
      _isPremium = status.isPremium && !status.isExpired;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Caffeine Tracking')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isPremium) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Caffeine Tracking'),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingXL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: DesignSystem.spacingXL),
                  Text(
                    'Premium Feature',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: DesignSystem.spacingM),
                  Text(
                    'Caffeine tracking is available for Premium users',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignSystem.spacingXXL),
                  ModernButton(
                    text: 'Go Premium',
                    icon: Icons.star_rounded,
                    isPrimary: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PremiumScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caffeine Tracking'),
      ),
      body: SafeArea(
        child: FutureBuilder<double>(
          future: _caffeineService.getTodayTotalMg(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final todayTotal = snapshot.data ?? 0.0;
            final limitPercentage = (todayTotal / CaffeineService.dailyLimitMg).clamp(0.0, 1.0);

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: DesignSystem.spacingL),
                  // Today's Total Card
                  ModernCard(
                    margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
                    child: Column(
                      children: [
                        Text(
                          'Today\'s Caffeine',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: DesignSystem.spacingM),
                        Text(
                          '${todayTotal.toStringAsFixed(0)} mg',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: DesignSystem.spacingS),
                        Text(
                          'of ${CaffeineService.dailyLimitMg.toInt()} mg daily limit',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: DesignSystem.spacingL),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(DesignSystem.radiusRound),
                          child: LinearProgressIndicator(
                            value: limitPercentage,
                            minHeight: 12,
                            backgroundColor: Theme.of(context).dividerColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              limitPercentage >= 1.0
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spacingS),
                        Text(
                          '${(limitPercentage * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXL),
                  // Quick Add Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Add',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: DesignSystem.spacingM),
                        Wrap(
                          spacing: DesignSystem.spacingS,
                          runSpacing: DesignSystem.spacingS,
                          children: CaffeineSource.values.map((source) {
                            final info = CaffeineSourceInfo.sources[source]!;
                            return _buildSourceButton(source, info);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXL),
                  // Today's Intakes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Intakes',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: DesignSystem.spacingM),
                        FutureBuilder<List<CaffeineIntake>>(
                          future: _caffeineService.getTodayIntakes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final intakes = snapshot.data ?? [];
                            if (intakes.isEmpty) {
                              return ModernCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(DesignSystem.spacingXL),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.local_cafe_outlined,
                                          size: 64,
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                        const SizedBox(height: DesignSystem.spacingM),
                                        Text(
                                          'No caffeine intake today',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: intakes.map((intake) {
                                final sourceInfo = CaffeineSourceInfo.sources[intake.source]!;
                                return ModernCard(
                                  margin: const EdgeInsets.only(bottom: DesignSystem.spacingS),
                                  onTap: () async {
                                    await _caffeineService.deleteCaffeineIntake(intake);
                                    setState(() {});
                                  },
                                  child: ListTile(
                                    leading: Container(
                                      padding: const EdgeInsets.all(DesignSystem.spacingS),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(DesignSystem.radiusSmall),
                                      ),
                                      child: Text(
                                        sourceInfo.emoji,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                    title: Text(
                                      sourceInfo.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      DateFormat('HH:mm').format(intake.dateTime),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${intake.amountMg.toStringAsFixed(0)} mg',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXL),
                  // Weekly Chart
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last 7 Days',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: DesignSystem.spacingM),
                        ModernCard(
                          padding: const EdgeInsets.all(DesignSystem.spacingL),
                          child: SizedBox(
                            height: 200,
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: _caffeineService.getLastNDaysSummaries(7),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final summaries = snapshot.data ?? [];
                                if (summaries.isEmpty) {
                                  return const Center(child: Text('No data'));
                                }

                                final maxMg = summaries.fold<double>(
                                  0.0,
                                  (max, s) => max > s['totalMg'] ? max : s['totalMg'],
                                );

                                return BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: maxMg > 0 ? maxMg * 1.2 : 100,
                                    barTouchData: BarTouchData(enabled: true),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            if (value.toInt() >= summaries.length) {
                                              return const Text('');
                                            }
                                            final date = summaries[value.toInt()]['date'] as DateTime;
                                            return Text(
                                              '${date.day}/${date.month}',
                                              style: const TextStyle(fontSize: 10),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              '${value.toInt()}mg',
                                              style: const TextStyle(fontSize: 10),
                                            );
                                          },
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                    ),
                                    gridData: FlGridData(show: true, drawVerticalLine: false),
                                    borderData: FlBorderData(show: false),
                                    barGroups: summaries.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final summary = entry.value;
                                      final totalMg = summary['totalMg'] as double;
                                      final isOverLimit = totalMg > CaffeineService.dailyLimitMg;

                                      return BarChartGroupData(
                                        x: index,
                                        barRods: [
                                          BarChartRodData(
                                            toY: totalMg,
                                            color: isOverLimit
                                                ? Theme.of(context).colorScheme.error
                                                : Theme.of(context).colorScheme.primary,
                                            width: 16,
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXL),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSourceButton(CaffeineSource source, CaffeineSourceInfo info) {
    return GestureDetector(
      onTap: () => _addCaffeine(source, info.defaultAmountMg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingM,
          vertical: DesignSystem.spacingS,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(info.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: DesignSystem.spacingS),
            Text(
              info.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCaffeine(CaffeineSource source, double amountMg) async {
    final intake = CaffeineIntake(
      dateTime: DateTime.now(),
      source: source,
      amountMg: amountMg,
    );
    await _caffeineService.addCaffeineIntake(intake);
    setState(() {});
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: DesignSystem.spacingS),
              Text('${amountMg.toStringAsFixed(0)} mg added!'),
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
}

