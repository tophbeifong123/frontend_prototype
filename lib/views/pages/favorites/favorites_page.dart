import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Pokémon'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'No Favorites Saved Yet',
                style: ShadTheme.of(context).textTheme.h4,
              ),
              const SizedBox(height: 8),
              Text(
                'Mark Pokémon as favorites to access them quickly.',
                style: ShadTheme.of(context).textTheme.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
