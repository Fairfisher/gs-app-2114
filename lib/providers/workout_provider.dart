import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fgitness/models/workout.dart';
import 'package:fgitness/services/storage_service.dart';
import 'package:intl/intl.dart';

class WorkoutsState {
  final List<Workout> workouts;
  final bool isLoading;

  const WorkoutsState({
    required this.workouts,
    this.isLoading = false,
  });

  List<Workout> get todayWorkouts {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return workouts.where((Workout workout) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      return workoutDate == today;
    }).toList();
  }

  WorkoutsState copyWith({
    List<Workout>? workouts,
    bool? isLoading,
  }) {
    return WorkoutsState(
      workouts: workouts ?? this.workouts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WorkoutsNotifier extends StateNotifier<WorkoutsState> {
  WorkoutsNotifier() : super(const WorkoutsState(workouts: <Workout>[])) {
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    state = state.copyWith(isLoading: true);
    final workouts = await StorageService.instance.getWorkouts();
    state = state.copyWith(workouts: workouts, isLoading: false);
  }

  Future<void> addWorkout(Workout workout) async {
    final updatedWorkouts = <Workout>[...state.workouts, workout];
    await StorageService.instance.saveWorkouts(updatedWorkouts);
    state = state.copyWith(workouts: updatedWorkouts);
  }

  Future<void> deleteWorkout(String id) async {
    final updatedWorkouts = state.workouts.where((Workout workout) => workout.id != id).toList();
    await StorageService.instance.saveWorkouts(updatedWorkouts);
    state = state.copyWith(workouts: updatedWorkouts);
  }
}

final workoutsProvider = StateNotifierProvider<WorkoutsNotifier, WorkoutsState>((ref) {
  return WorkoutsNotifier();
});
