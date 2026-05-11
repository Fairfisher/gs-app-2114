import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fgitness/models/user.dart';
import 'package:fgitness/services/storage_service.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(const User(
          name: 'User',
          email: 'user@example.com',
          calorieGoal: 2000,
          proteinGoal: 150,
          carbsGoal: 200,
          fatGoal: 65,
          weight: 70.0,
          height: 170,
          age: 25,
        )) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await StorageService.instance.getUser();
    state = user;
  }

  Future<void> updateUser({
    String? name,
    String? email,
    int? calorieGoal,
    int? proteinGoal,
    int? carbsGoal,
    int? fatGoal,
    double? weight,
    int? height,
    int? age,
  }) async {
    final updatedUser = state.copyWith(
      name: name,
      email: email,
      calorieGoal: calorieGoal,
      proteinGoal: proteinGoal,
      carbsGoal: carbsGoal,
      fatGoal: fatGoal,
      weight: weight,
      height: height,
      age: age,
    );
    await StorageService.instance.saveUser(updatedUser);
    state = updatedUser;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
