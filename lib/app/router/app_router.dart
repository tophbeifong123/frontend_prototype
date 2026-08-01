import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/details/presentation/screens/item_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Centralized GoRouter configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id'] ?? 'unknown';
            return ItemDetailScreen(itemId: id);
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
      ],
    ),
  ],
);
