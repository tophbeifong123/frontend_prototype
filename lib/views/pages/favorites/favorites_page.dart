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
    appBar: AppBar(title: const Text('Favorite Pokémon')),
    body: BlocBuilder<FavoritesCubit, Map<int, PokemonListItem>>(
      builder: (context, favorites) {
        final pokemon = favorites.values.toList();
        if (pokemon.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'No favorite Pokémon yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the heart on any Pokémon card to save it here.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pokemon.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .82,
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
    ),
  );
}
