import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fgitness/models/workout.dart';
import 'package:fgitness/providers/workout_provider.dart';
import 'package:fgitness/widgets/workout_card.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsState = ref.watch(workoutsProvider);
    final allWorkouts = workoutsState.workouts;

    final groupedWorkouts = <String, List<Workout>>{};
    for (final Workout workout in allWorkouts) {
      final dateKey = DateFormat('yyyy-MM-dd').format(workout.date);
      if (!groupedWorkouts.containsKey(dateKey)) {
        groupedWorkouts[dateKey] = <Workout>[];
      }
      groupedWorkouts[dateKey]!.add(workout);
    }

    final sortedKeys = groupedWorkouts.keys.toList()
      ..sort((String a, String b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: allWorkouts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fitness_center_outlined,
                    size: 64,
                    color: Color(0xFF5A5A5A),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No workouts yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start tracking your fitness journey',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed('add-workout');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Workout'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(workoutsProvider);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sortedKeys.length,
                itemBuilder: (context, index) {
                  final dateKey = sortedKeys[index];
                  final workouts = groupedWorkouts[dateKey]!;
                  final date = DateTime.parse(dateKey);
                  final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == dateKey;
                  final isYesterday = DateFormat('yyyy-MM-dd').format(
                        DateTime.now().subtract(const Duration(days: 1)),
                      ) ==
                      dateKey;

                  String dateLabel;
                  if (isToday) {
                    dateLabel = 'Today';
                  } else if (isYesterday) {
                    dateLabel = 'Yesterday';
                  } else {
                    dateLabel = DateFormat('EEEE, MMM d').format(date);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index > 0) const SizedBox(height: 24),
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ...workouts.map((Workout workout) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WorkoutCard(
                              workout: workout,
                              onDelete: () {
                                ref.read(workoutsProvider.notifier).deleteWorkout(workout.id);
                              },
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
      floatingActionButton: allWorkouts.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                context.pushNamed('add-workout');
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
