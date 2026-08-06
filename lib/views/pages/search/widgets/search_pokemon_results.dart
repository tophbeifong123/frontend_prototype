import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/pokemon.dart';
import '../../../widgets/pokemon_card.dart';

class PokemonResults extends StatelessWidget {
  const PokemonResults({
    super.key,
    required this.future,
    required this.query,
    required this.hasFilters,
    required this.onClear,
    required this.onRetry,
  });

  final Future<List<PokemonListItem>> future;
  final String query;
  final bool hasFilters;
  final VoidCallback? onClear;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<PokemonListItem>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 48),
                    const SizedBox(height: 12),
                    const Text('Could not load Pokémon.'),
                    TextButton(onPressed: onRetry, child: const Text('Try again')),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(36),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final pokemon = snapshot.data!
              .where((item) => query.isEmpty || item.name.toLowerCase().contains(query))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hasFilters ? 'Matching Pokémon' : 'Search results',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (onClear != null)
                    TextButton(onPressed: onClear, child: const Text('Clear all')),
                ],
              ),
              const SizedBox(height: 8),
              if (pokemon.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(36),
                  child: Center(child: Text('No Pokémon found.')),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.maxWidth >= 1200) {
                      crossAxisCount = 5;
                    } else if (constraints.maxWidth >= 800) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth >= 600) {
                      crossAxisCount = 3;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pokemon.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index) {
                        final item = pokemon[index];
                        return FavoritePokemonCard(
                          pokemon: item,
                          onTap: () => context.push('/home/detail/${item.id}'),
                        );
                      },
                    );
                  },
                ),
            ],
          );
        },
      );
}
