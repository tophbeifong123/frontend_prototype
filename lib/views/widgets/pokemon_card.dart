import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../models/pokemon.dart';

/// Reusable Pokémon Card component for grid and list views.
class PokemonCard extends StatelessWidget {
  final PokemonListItem pokemon;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    this.isFavorite = false,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';

    return Stack(
      children: [
        GestureDetector(
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
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Center(
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
        if (onFavorite != null)
          Positioned(
            top: 2,
            right: 2,
            child: IconButton(
              tooltip: isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
              onPressed: onFavorite,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.redAccent : null,
              ),
            ),
          ),
      ],
    );
  }
}

/// Rebuilds only this card when its own favorite state changes.
class FavoritePokemonCard extends StatelessWidget {
  const FavoritePokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  final PokemonListItem pokemon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      BlocSelector<FavoritesCubit, Map<int, PokemonListItem>, bool>(
        selector: (favorites) => favorites.containsKey(pokemon.id),
        builder: (context, isFavorite) => PokemonCard(
          pokemon: pokemon,
          onTap: onTap,
          isFavorite: isFavorite,
          onFavorite: () => context.read<FavoritesCubit>().toggle(pokemon),
        ),
      );
}
