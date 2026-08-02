import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pokemon.dart';

/// Holds the Pokémon marked as favorites for the active app session.
class FavoritesCubit extends Cubit<Map<int, PokemonListItem>> {
  FavoritesCubit() : super(const {});

  bool isFavorite(int pokemonId) => state.containsKey(pokemonId);

  void toggle(PokemonListItem pokemon) {
    final updated = Map<int, PokemonListItem>.from(state);
    if (updated.containsKey(pokemon.id)) {
      updated.remove(pokemon.id);
    } else {
      updated[pokemon.id] = pokemon;
    }
    emit(Map.unmodifiable(updated));
  }
}
