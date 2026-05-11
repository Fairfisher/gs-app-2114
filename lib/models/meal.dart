import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime date;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date': date.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      carbs: json['carbs'] as int,
      fat: json['fat'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, calories, protein, carbs, fat, date];
}
