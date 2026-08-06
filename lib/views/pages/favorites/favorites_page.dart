import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../blocs/favorites/favorites_cubit.dart';
import '../../../models/pokemon.dart';
import '../../widgets/pokemon_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFEAF1F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEAF1F7),
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'Favorite Pokémon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0A1C2C),
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<FavoritesCubit, Map<int, PokemonListItem>>(
          builder: (context, favorites) {
            final pokemon = favorites.values.toList();
            if (pokemon.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.favorite_rounded,
                        size: 72,
                        color: Color(0xFFD3E0EA),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorite Pokémon yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0A1C2C),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the heart on any Pokémon card to save your favorites here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A6E7F),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return LayoutBuilder(
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  physics: const BouncingScrollPhysics(),
                  itemCount: pokemon.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final item = pokemon[index];
                    return PokemonCard(
                      pokemon: item,
                      isFavorite: true,
                      onFavorite: () => context.read<FavoritesCubit>().toggle(item),
                      onTap: () => context.push('/home/detail/${item.id}'),
                    );
                  },
                );
              },
            );
          },
        ),
      );
}
