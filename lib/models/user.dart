import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;
  final int calorieGoal;
  final int proteinGoal;
  final int carbsGoal;
  final int fatGoal;
  final double weight;
  final int height;
  final int age;

  const User({
    required this.name,
    required this.email,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.weight,
    required this.height,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'calorieGoal': calorieGoal,
      'proteinGoal': proteinGoal,
      'carbsGoal': carbsGoal,
      'fatGoal': fatGoal,
      'weight': weight,
      'height': height,
      'age': age,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      calorieGoal: json['calorieGoal'] as int,
      proteinGoal: json['proteinGoal'] as int,
      carbsGoal: json['carbsGoal'] as int,
      fatGoal: json['fatGoal'] as int,
      weight: (json['weight'] as num).toDouble(),
      height: json['height'] as int,
      age: json['age'] as int,
    );
  }

  User copyWith({
    String? name,
    String? email,
    int? calorieGoal,
    int? proteinGoal,
    int? carbsGoal,
    int? fatGoal,
    double? weight,
    int? height,
    int? age,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        calorieGoal,
        proteinGoal,
        carbsGoal,
        fatGoal,
        weight,
        height,
        age,
      ];
}
