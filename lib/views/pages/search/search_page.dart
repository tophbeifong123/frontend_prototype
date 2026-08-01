import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../widgets/empty_placeholder.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Pokémon'),
        centerTitle: false,
      ),
      body: const EmptyPlaceholder(
        icon: LucideIcons.construction,
        title: 'Search Feature Under Construction',
        description: 'Advanced PokéAPI search & filtering capability will be available soon!',
      ),
    );
  }
}
