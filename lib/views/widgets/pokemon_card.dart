import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../models/pokemon.dart';

/// Reusable Pokémon Card component for grid and list views.
class PokemonCard extends StatelessWidget {
  final PokemonListItem pokemon;
  final VoidCallback onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: ShadCard(
        title: Text(
          '$formattedId ${pokemon.name.toUpperCase()}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        child: Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.network(
                pokemon.imageUrl,
                height: 100,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.catching_pokemon,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
