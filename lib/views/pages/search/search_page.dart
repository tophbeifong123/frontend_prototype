import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ShadInput(
              placeholder: Text('Search by name or PokéAPI ID...'),
              leading: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.search, size: 18),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Search results from PokéAPI will appear here.',
                  style: ShadTheme.of(context).textTheme.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
