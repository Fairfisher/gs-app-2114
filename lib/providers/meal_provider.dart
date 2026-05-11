import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fgitness/models/meal.dart';
import 'package:fgitness/services/storage_service.dart';
import 'package:intl/intl.dart';

class MealsState {
  final List<Meal> meals;
  final bool isLoading;

  const MealsState({
    required this.meals,
    this.isLoading = false,
  });

  List<Meal> get todayMeals {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return meals.where((Meal meal) {
      final mealDate = DateFormat('yyyy-MM-dd').format(meal.date);
      return mealDate == today;
    }).toList();
  }

  MealsState copyWith({
    List<Meal>? meals,
    bool? isLoading,
  }) {
    return MealsState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MealsNotifier extends StateNotifier<MealsState> {
  MealsNotifier() : super(const MealsState(meals: <Meal>[])) {
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    state = state.copyWith(isLoading: true);
    final meals = await StorageService.instance.getMeals();
    state = state.copyWith(meals: meals, isLoading: false);
  }

  Future<void> addMeal(Meal meal) async {
    final updatedMeals = <Meal>[...state.meals, meal];
    await StorageService.instance.saveMeals(updatedMeals);
    state = state.copyWith(meals: updatedMeals);
  }

  Future<void> deleteMeal(String id) async {
    final updatedMeals = state.meals.where((Meal meal) => meal.id != id).toList();
    await StorageService.instance.saveMeals(updatedMeals);
    state = state.copyWith(meals: updatedMeals);
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, MealsState>((ref) {
  return MealsNotifier();
});
