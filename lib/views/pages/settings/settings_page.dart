import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../widgets/empty_placeholder.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        centerTitle: false,
      ),
      body: const EmptyPlaceholder(
        icon: LucideIcons.construction,
        title: 'Settings Under Construction',
        description: 'PokéAPI cache configuration and audio settings will be available soon!',
      ),
    );
  }
}
