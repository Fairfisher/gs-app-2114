import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fgitness/models/meal.dart';
import 'package:fgitness/models/workout.dart';
import 'package:fgitness/providers/meal_provider.dart';
import 'package:fgitness/providers/workout_provider.dart';
import 'package:fgitness/providers/user_provider.dart';
import 'package:fgitness/widgets/calorie_ring.dart';
import 'package:fgitness/widgets/macro_bar.dart';
import 'package:fgitness/widgets/meal_card.dart';
import 'package:fgitness/widgets/workout_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final mealsState = ref.watch(mealsProvider);
    final workoutsState = ref.watch(workoutsProvider);

    final todayMeals = mealsState.todayMeals;
    final todayWorkouts = workoutsState.todayWorkouts;

    final totalCalories = todayMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.calories,
    );
    final totalProtein = todayMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.protein,
    );
    final totalCarbs = todayMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.carbs,
    );
    final totalFat = todayMeals.fold<int>(
      0,
      (int sum, Meal meal) => sum + meal.fat,
    );
    final caloriesBurned = todayWorkouts.fold<int>(
      0,
      (int sum, Workout workout) => sum + workout.caloriesBurned,
    );

    final calorieGoal = userState.calorieGoal;
    final proteinGoal = userState.proteinGoal;
    final carbsGoal = userState.carbsGoal;
    final fatGoal = userState.fatGoal;

    final netCalories = totalCalories - caloriesBurned;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FGitness'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushNamed('settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(mealsProvider);
          ref.invalidate(workoutsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${userState.name}',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEEE, MMM d').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              CalorieRing(
                consumed: totalCalories,
                burned: caloriesBurned,
                goal: calorieGoal,
              ),
              const SizedBox(height: 24),
              Text(
                'Macros',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              MacroBar(
                label: 'Protein',
                current: totalProtein,
                goal: proteinGoal,
                unit: 'g',
                color: const Color(0xFF4CAF50),
              ),
              const SizedBox(height: 12),
              MacroBar(
                label: 'Carbs',
                current: totalCarbs,
                goal: carbsGoal,
                unit: 'g',
                color: const Color(0xFF4A90E2),
              ),
              const SizedBox(height: 12),
              MacroBar(
                label: 'Fat',
                current: totalFat,
                goal: fatGoal,
                unit: 'g',
                color: const Color(0xFFFF9800),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meals',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF4A90E2)),
                    onPressed: () {
                      context.pushNamed('add-meal');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (todayMeals.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No meals logged yet. Tap + to add one.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ...todayMeals.map((Meal meal) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MealCard(
                        meal: meal,
                        onDelete: () {
                          ref.read(mealsProvider.notifier).deleteMeal(meal.id);
                        },
                      ),
                    )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Workouts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF4A90E2)),
                    onPressed: () {
                      context.pushNamed('add-workout');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (todayWorkouts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No workouts logged yet. Tap + to add one.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ...todayWorkouts.map((Workout workout) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: WorkoutCard(
                        workout: workout,
                        onDelete: () {
                          ref.read(workoutsProvider.notifier).deleteWorkout(workout.id);
                        },
                      ),
                    )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
