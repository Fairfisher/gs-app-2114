import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fgitness/models/meal.dart';
import 'package:fgitness/models/workout.dart';
import 'package:fgitness/models/user.dart';

class StorageService {
  static final StorageService instance = StorageService._internal();
  factory StorageService() => instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized');
    }
    return _prefs!;
  }

  Future<List<Meal>> getMeals() async {
    final jsonString = prefs.getString('meals');
    if (jsonString == null) {
      return <Meal>[];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList.map((dynamic json) => Meal.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> saveMeals(List<Meal> meals) async {
    final jsonList = meals.map((Meal meal) => meal.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('meals', jsonString);
  }

  Future<List<Workout>> getWorkouts() async {
    final jsonString = prefs.getString('workouts');
    if (jsonString == null) {
      return <Workout>[];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList.map((dynamic json) => Workout.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> saveWorkouts(List<Workout> workouts) async {
    final jsonList = workouts.map((Workout workout) => workout.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('workouts', jsonString);
  }

  Future<User> getUser() async {
    final jsonString = prefs.getString('user');
    if (jsonString == null) {
      return const User(
        name: 'User',
        email: 'user@example.com',
        calorieGoal: 2000,
        proteinGoal: 150,
        carbsGoal: 200,
        fatGoal: 65,
        weight: 70.0,
        height: 170,
        age: 25,
      );
    }
    final Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  Future<void> saveUser(User user) async {
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString('user', jsonString);
  }
}
