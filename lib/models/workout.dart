import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String id;
  final String name;
  final int duration;
  final int caloriesBurned;
  final DateTime date;

  const Workout({
    required this.id,
    required this.name,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: json['duration'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, duration, caloriesBurned, date];
}
