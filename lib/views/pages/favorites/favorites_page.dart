import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Pokémon'),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.construction,
                size: 64,
                color: ShadTheme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Favorites Feature Under Construction',
                style: ShadTheme.of(context).textTheme.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Personal favorite Pokémon collection management will be available soon!',
                style: ShadTheme.of(context).textTheme.muted,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
