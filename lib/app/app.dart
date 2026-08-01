import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Main Application Entry Widget with ThemeData and GoRouter integration.
class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Frontend Prototype',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
