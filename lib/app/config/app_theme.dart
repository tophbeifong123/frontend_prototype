import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// AppTheme configuration for PokéAPI application using Shadcn UI theme specifications.
abstract class AppTheme {
  /// Light Theme with ShadZincColorScheme.light() and 8px radius
  static ShadThemeData get lightTheme {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadZincColorScheme.light(),
      radius: const BorderRadius.all(Radius.circular(8)),
    );
  }

  /// Dark Theme with ShadZincColorScheme.dark() and 8px radius
  static ShadThemeData get darkTheme {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadZincColorScheme.dark(),
      radius: const BorderRadius.all(Radius.circular(8)),
    );
  }
}
