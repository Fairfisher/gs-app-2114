import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fgitness/pages/home_page.dart';
import 'package:fgitness/pages/activity_page.dart';
import 'package:fgitness/pages/stats_page.dart';
import 'package:fgitness/pages/profile_page.dart';
import 'package:fgitness/pages/add_meal_page.dart';
import 'package:fgitness/pages/add_workout_page.dart';
import 'package:fgitness/pages/settings_page.dart';
import 'package:fgitness/widgets/main_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/activity',
            name: 'activity',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ActivityPage(),
            ),
          ),
          GoRoute(
            path: '/stats',
            name: 'stats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/add-meal',
        name: 'add-meal',
        builder: (context, state) => const AddMealPage(),
      ),
      GoRoute(
        path: '/add-workout',
        name: 'add-workout',
        builder: (context, state) => const AddWorkoutPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
