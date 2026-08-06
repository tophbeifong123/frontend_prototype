import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../blocs/favorites/favorites_cubit.dart';
import '../../core/utils/pokemon_type_helper.dart';
import '../../models/pokemon.dart';

/// Minimal, Nintendo Switch inspired Pokémon Card component with Pokéball background watermark.
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

  String _getPrimaryType() {
    final id = pokemon.id;
    if (id == 1 || id == 2 || id == 3 || id == 43 || id == 44 || id == 45) return 'grass';
    if (id == 4 || id == 5 || id == 6 || id == 37 || id == 38 || id == 58) return 'fire';
    if (id == 7 || id == 8 || id == 9 || id == 54 || id == 55 || id == 60) return 'water';
    if (id == 25 || id == 26 || id == 100 || id == 101 || id == 125) return 'electric';
    if (id == 63 || id == 64 || id == 65 || id == 150 || id == 151) return 'psychic';

    return switch (id % 5) {
      1 => 'grass',
      2 => 'fire',
      3 => 'water',
      4 => 'electric',
      _ => 'normal',
    };
  }

  List<PokemonTypeInfo> _getTypeBadges() {
    final id = pokemon.id;
    if (id == 1 || id == 2 || id == 3) {
      return [
        PokemonTypeHelper.getTypeInfo('grass'),
        PokemonTypeHelper.getTypeInfo('poison'),
      ];
    } else if (id == 4 || id == 5) {
      return [PokemonTypeHelper.getTypeInfo('fire')];
    } else if (id == 6) {
      return [
        PokemonTypeHelper.getTypeInfo('fire'),
        PokemonTypeHelper.getTypeInfo('flying'),
      ];
    } else if (id >= 7 && id <= 9) {
      return [PokemonTypeHelper.getTypeInfo('water')];
    } else if (id == 25 || id == 26) {
      return [PokemonTypeHelper.getTypeInfo('electric')];
    }

    return [PokemonTypeHelper.getTypeInfo(_getPrimaryType())];
  }

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';
    final primaryType = _getPrimaryType();
    final typeInfo = PokemonTypeHelper.getTypeInfo(primaryType);
    final pastelColor = typeInfo.pastelBackgroundColor;
    final typeBadges = _getTypeBadges();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: pastelColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A1C2C).withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: typeInfo.color.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // PokéBall Background Watermark Pattern
              Positioned(
                right: -24,
                bottom: -24,
                child: Icon(
                  Icons.catching_pokemon,
                  size: 130,
                  color: Colors.black.withValues(alpha: 0.04),
                ),
              ),

              // Card Content Area
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Details: #ID, Name, and Favorite Heart Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedId,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5A6E7F),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pokemon.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0A1C2C),
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (onFavorite != null)
                          InkWell(
                            onTap: onFavorite,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.redAccent : const Color(0xFF0A1C2C),
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Floating Artwork Image
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Image.network(
                            pokemon.imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.catching_pokemon,
                              size: 54,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Type Badges (Solid type background with white icon & text)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: typeBadges.map((badge) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: badge.color,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: badge.color.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(badge.icon, size: 11, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                badge.displayName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
          onFavorite: () {
            final cubit = context.read<FavoritesCubit>();
            final wasFavorite = isFavorite;
            cubit.toggle(pokemon);

            final formattedId = '#${pokemon.id.toString().padLeft(3, '0')}';
            final name = pokemon.name.toUpperCase();

            if (!wasFavorite) {
              ShadToaster.of(context).show(
                ShadToast(
                  alignment: Alignment.topLeft,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '$formattedId $name added!',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  description: const Text('Saved to your favorite Pokémon list.'),
                ),
              );
            } else {
              ShadToaster.of(context).show(
                ShadToast(
                  alignment: Alignment.topLeft,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite_border, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '$formattedId $name removed',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  description: const Text('Removed from your favorite Pokémon list.'),
                ),
              );
            }
          },
        ),
      );
}
