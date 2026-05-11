import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fgitness/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushNamed('settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFF4A90E2),
              child: Icon(
                Icons.person,
                size: 48,
                color: Color(0xFFFFFFFF),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userState.name,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 8),
            Text(
              userState.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.restaurant, color: Color(0xFF4A90E2)),
                    title: const Text('Calorie Goal'),
                    trailing: Text(
                      '${userState.calorieGoal} kcal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.fitness_center, color: Color(0xFF4CAF50)),
                    title: const Text('Protein Goal'),
                    trailing: Text(
                      '${userState.proteinGoal} g',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.grain, color: Color(0xFF4A90E2)),
                    title: const Text('Carbs Goal'),
                    trailing: Text(
                      '${userState.carbsGoal} g',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.water_drop, color: Color(0xFFFF9800)),
                    title: const Text('Fat Goal'),
                    trailing: Text(
                      '${userState.fatGoal} g',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.scale, color: Color(0xFFA0A0A0)),
                    title: const Text('Weight'),
                    trailing: Text(
                      '${userState.weight.toStringAsFixed(1)} kg',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.height, color: Color(0xFFA0A0A0)),
                    title: const Text('Height'),
                    trailing: Text(
                      '${userState.height} cm',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.cake, color: Color(0xFFA0A0A0)),
                    title: const Text('Age'),
                    trailing: Text(
                      '${userState.age} years',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
