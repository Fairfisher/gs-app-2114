import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fgitness/models/meal.dart';
import 'package:fgitness/models/workout.dart';
import 'package:fgitness/providers/meal_provider.dart';
import 'package:fgitness/providers/workout_provider.dart';
import 'package:fgitness/providers/user_provider.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  int _selectedPeriod = 7;

  @override
  Widget build(BuildContext context) {
    final mealsState = ref.watch(mealsProvider);
    final workoutsState = ref.watch(workoutsProvider);
    final userState = ref.watch(userProvider);

    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _selectedPeriod - 1));

    final periodMeals = mealsState.meals.where((Meal meal) {
      return meal.date.isAfter(startDate.subtract(const Duration(days: 1)));
    }).toList();

    final periodWorkouts = workoutsState.workouts.where((Workout workout) {
      return workout.date.isAfter(startDate.subtract(const Duration(days: 1)));
    }).toList();

    final dailyCalories = <String, int>{};
    final dailyBurned = <String, int>{};

    for (int i = 0; i < _selectedPeriod; i++) {
      final date = startDate.add(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      dailyCalories[dateKey] = 0;
      dailyBurned[dateKey] = 0;
    }

    for (final Meal meal in periodMeals) {
      final dateKey = DateFormat('yyyy-MM-dd').format(meal.date);
      dailyCalories[dateKey] = (dailyCalories[dateKey] ?? 0) + meal.calories;
    }

    for (final Workout workout in periodWorkouts) {
      final dateKey = DateFormat('yyyy-MM-dd').format(workout.date);
      dailyBurned[dateKey] = (dailyBurned[dateKey] ?? 0) + workout.caloriesBurned;
    }

    final totalCalories = periodMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.calories,
    );
    final totalBurned = periodWorkouts.fold<int>(
      0,
      (int sum, Workout workout) => sum + workout.caloriesBurned,
    );
    final avgCalories = periodMeals.isNotEmpty ? totalCalories ~/ _selectedPeriod : 0;
    final avgBurned = periodWorkouts.isNotEmpty ? totalBurned ~/ _selectedPeriod : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('7 Days'),
                    selected: _selectedPeriod == 7,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = 7;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('30 Days'),
                    selected: _selectedPeriod == 30,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = 30;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('90 Days'),
                    selected: _selectedPeriod == 90,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPeriod = 90;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calorie Intake',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= dailyCalories.length) {
                                    return const SizedBox();
                                  }
                                  final date = startDate.add(Duration(days: value.toInt()));
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      DateFormat('d').format(date),
                                      style: const TextStyle(
                                        color: Color(0xFFA0A0A0),
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dailyCalories.entries.toList().asMap().entries.map((entry) {
                                return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
                              }).toList(),
                              isCurved: true,
                              color: const Color(0xFF4A90E2),
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0xFF4A90E2).withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Burned',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= dailyBurned.length) {
                                    return const SizedBox();
                                  }
                                  final date = startDate.add(Duration(days: value.toInt()));
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      DateFormat('d').format(date),
                                      style: const TextStyle(
                                        color: Color(0xFFA0A0A0),
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: dailyBurned.entries.toList().asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.value.toDouble(),
                                  color: const Color(0xFFFF9800),
                                  width: 16,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Avg. Daily Intake',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '$avgCalories kcal',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF4A90E2),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Avg. Daily Burned',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '$avgBurned kcal',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFFFF9800),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Net Avg.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${avgCalories - avgBurned} kcal',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF4CAF50),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
