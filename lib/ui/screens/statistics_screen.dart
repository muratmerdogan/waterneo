import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../config/app_strings.dart';
import '../../config/design_system.dart';
import '../../utils/providers.dart';
import '../widgets/modern_card.dart';

/// İstatistikler ekranı - Grafikler ve özet bilgiler
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettings = ref.watch(userSettingsProvider);
    final waterIntakeService = ref.read(waterIntakeServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.statistics),
      ),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
        future: waterIntakeService.getLastNDaysSummaries(
          30,
          userSettings.dailyGoal,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final summaries = snapshot.data ?? [];
          final last7Days = summaries.length > 7
              ? summaries.sublist(summaries.length - 7)
              : summaries;
          final last30Days = summaries;
          final previous7Days = summaries.length > 14
              ? summaries.sublist(summaries.length - 14, summaries.length - 7)
              : [];
          final thisWeek = last7Days;
          final lastWeek = previous7Days;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Son 7 gün grafiği
                _buildSectionTitle(context, AppStrings.last7Days),
                _buildBarChart(context, last7Days, userSettings, isCompact: false),
                const SizedBox(height: 32),
                // Son 30 gün grafiği - İyileştirilmiş
                _buildSectionTitle(context, AppStrings.last30Days),
                _buildLineChart(context, last30Days, userSettings),
                const SizedBox(height: 24),
                // 30 gün bar chart (alternatif görünüm)
                _buildBarChart(context, last30Days, userSettings, isCompact: true),
                const SizedBox(height: 24),
                // İstatistikler kartları
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          AppStrings.averageDaily,
                          _calculateAverage(last30Days, userSettings),
                          userSettings.unitLabel,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          AppStrings.totalIntake,
                          _calculateTotal(last30Days, userSettings),
                          userSettings.unitLabel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Weekly Comparison
                if (thisWeek.isNotEmpty && lastWeek.isNotEmpty)
                  _buildWeeklyComparison(context, thisWeek, lastWeek, userSettings),
                if (thisWeek.isNotEmpty && lastWeek.isNotEmpty)
                  const SizedBox(height: 24),
                // En iyi seri
                _buildBestStreakCard(context, last30Days),
                const SizedBox(height: 24),
                // Best Day
                _buildBestDayCard(context, last30Days, userSettings),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildBarChart(
      BuildContext context, List<dynamic> summaries, dynamic userSettings,
      {bool isCompact = false}) {
    if (summaries.isEmpty) {
      return SizedBox(height: isCompact ? 250 : 200);
    }

    final chartHeight = isCompact ? 250.0 : 200.0;
    final barWidth = isCompact ? 8.0 : 16.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: chartHeight,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: userSettings.dailyGoal * 1.2 / 1000, // L cinsinden
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Theme.of(context).cardColor,
                  tooltipRoundedRadius: 8,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= summaries.length) {
                        return const Text('');
                      }
                      final date = summaries[value.toInt()].date;
                      // Kompakt modda her 5 günde bir göster
                      if (isCompact && summaries.length > 20) {
                        if (value.toInt() % 5 != 0 && value.toInt() != summaries.length - 1) {
                          return const Text('');
                        }
                      }
                      return Text(
                        '${date.day}/${date.month}',
                        style: TextStyle(
                          fontSize: isCompact ? 9 : 10,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}L',
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
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: summaries.asMap().entries.map((entry) {
                final index = entry.key;
                final summary = entry.value;
                final amount = userSettings.convertToUnit(summary.totalAmount) /
                    1000; // L cinsinden
                final isReached = summary.isTargetReached;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: amount,
                      color: isReached
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                      width: barWidth,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, double value, String unit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(1)} $unit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestStreakCard(BuildContext context, List<dynamic> summaries) {
    int bestStreak = 0;
    int currentStreak = 0;

    for (final summary in summaries.reversed) {
      if (summary.isTargetReached) {
        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.bestStreak,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$bestStreak ${AppStrings.days}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverage(List<dynamic> summaries, dynamic userSettings) {
    if (summaries.isEmpty) return 0.0;
    final total = summaries.fold<double>(
      0.0,
      (sum, s) => sum + userSettings.convertToUnit(s.totalAmount),
    );
    return total / summaries.length;
  }

  double _calculateTotal(List<dynamic> summaries, dynamic userSettings) {
    return summaries.fold<double>(
      0.0,
      (sum, s) => sum + userSettings.convertToUnit(s.totalAmount),
    );
  }

  /// 30 günlük çizgi grafik oluştur
  Widget _buildLineChart(
      BuildContext context, List<dynamic> summaries, dynamic userSettings) {
    if (summaries.isEmpty) {
      return const SizedBox(height: 300);
    }

    final maxAmount = summaries.fold<double>(
      0.0,
      (max, s) => max > userSettings.convertToUnit(s.totalAmount) / 1000
          ? max
          : userSettings.convertToUnit(s.totalAmount) / 1000,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxAmount > 0 ? maxAmount / 5 : 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: summaries.length > 20 ? 5 : 3,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= summaries.length) {
                        return const Text('');
                      }
                      final date = summaries[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${date.day}/${date.month}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: maxAmount > 0 ? maxAmount / 5 : 1,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}L',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
              ),
              minX: 0,
              maxX: (summaries.length - 1).toDouble(),
              minY: 0,
              maxY: maxAmount * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: summaries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final summary = entry.value;
                    final amount =
                        userSettings.convertToUnit(summary.totalAmount) / 1000;
                    return FlSpot(index.toDouble(), amount);
                  }).toList(),
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: summaries.length <= 30,
                    getDotPainter: (spot, percent, barData, index) {
                      final summary = summaries[index.toInt()];
                      return FlDotCirclePainter(
                        radius: 4,
                        color: summary.isTargetReached
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                        strokeWidth: 2,
                        strokeColor: Theme.of(context).scaffoldBackgroundColor,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.1),
                  ),
                ),
                // Hedef çizgisi
                LineChartBarData(
                  spots: [
                    FlSpot(0, userSettings.dailyGoal / 1000),
                    FlSpot(
                      (summaries.length - 1).toDouble(),
                      userSettings.dailyGoal / 1000,
                    ),
                  ],
                  isCurved: false,
                  color: Theme.of(context).colorScheme.secondary,
                  barWidth: 2,
                  dashArray: [5, 5],
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyComparison(
    BuildContext context,
    List<dynamic> thisWeek,
    List<dynamic> lastWeek,
    dynamic userSettings,
  ) {
    final thisWeekAvg = _calculateAverage(thisWeek, userSettings);
    final lastWeekAvg = _calculateAverage(lastWeek, userSettings);
    final difference = thisWeekAvg - lastWeekAvg;
    final percentageChange = lastWeekAvg > 0
        ? ((difference / lastWeekAvg) * 100)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
      child: ModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Comparison',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: DesignSystem.spacingL),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'This Week',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: DesignSystem.spacingS),
                      Text(
                        '${thisWeekAvg.toStringAsFixed(1)} ${userSettings.unitLabel}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Theme.of(context).dividerColor,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Last Week',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: DesignSystem.spacingS),
                      Text(
                        '${lastWeekAvg.toStringAsFixed(1)} ${userSettings.unitLabel}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingL),
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              decoration: BoxDecoration(
                color: difference >= 0
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    difference >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: difference >= 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: DesignSystem.spacingS),
                  Text(
                    difference >= 0 ? '+' : '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: difference >= 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                  ),
                  Text(
                    '${difference.abs().toStringAsFixed(1)} ${userSettings.unitLabel}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: difference >= 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                  ),
                  const SizedBox(width: DesignSystem.spacingS),
                  Text(
                    '(${percentageChange.abs().toStringAsFixed(1)}%)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: difference >= 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestDayCard(
    BuildContext context,
    List<dynamic> summaries,
    dynamic userSettings,
  ) {
    if (summaries.isEmpty) return const SizedBox.shrink();

    dynamic bestDay = summaries[0];
    double bestAmount = 0.0;

    for (final summary in summaries) {
      final amount = userSettings.convertToUnit(summary.totalAmount);
      if (amount > bestAmount) {
        bestAmount = amount;
        bestDay = summary;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
      child: ModernCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
              ),
              child: const Text('🏆', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: DesignSystem.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Hydration Day',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    '${bestAmount.toStringAsFixed(1)} ${userSettings.unitLabel}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    DateFormat('MMMM d, yyyy').format(bestDay.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

