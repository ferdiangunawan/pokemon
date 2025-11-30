import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../../domain/index.dart';
import '../../presentation/index.dart';

/// Application router using GoRouter with custom transitions
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/pokemon/:id',
        name: 'pokemon-detail',
        builder: (context, state) {
          final idString = state.pathParameters['id'] ?? '1';
          final id = int.tryParse(idString) ?? 1;

          // Get pokemon from extra if passed
          Pokemon? pokemon;
          if (state.extra != null && state.extra is Pokemon) {
            pokemon = state.extra as Pokemon;
          }

          return PokemonDetailPage(pokemonId: id, pokemon: pokemon);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
