import 'package:go_router/go_router.dart';
import '../../views/main_tree.dart';
import '../../views/pages/auth/login_page.dart';
import '../../views/pages/auth/register_page.dart';
import '../../views/pages/favorites/favorites_page.dart';
import '../../views/pages/home/detail_page.dart';
import '../../views/pages/home/home_page.dart';
import '../../views/pages/profile/profile_page.dart';
import '../../views/pages/search/search_page.dart';
import '../../views/pages/settings/settings_page.dart';

/// AppRoutes configuration using GoRouter and ShellRoute.
abstract class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainTree(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '1';
                  return DetailPage(id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
