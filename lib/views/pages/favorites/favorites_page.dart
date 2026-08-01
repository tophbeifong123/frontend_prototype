import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../widgets/empty_placeholder.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Pokémon'),
        centerTitle: false,
      ),
      body: const EmptyPlaceholder(
        icon: LucideIcons.construction,
        title: 'Favorites Feature Under Construction',
        description: 'Personal favorite Pokémon collection management will be available soon!',
      ),
    );
  }
}
