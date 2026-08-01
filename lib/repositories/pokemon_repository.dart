import '../models/pokemon.dart';
import '../services/poke_api_service.dart';

/// Repository for Pokémon data abstraction.
class PokemonRepository {
  final PokeApiService apiService;

  PokemonRepository({PokeApiService? apiService})
      : apiService = apiService ?? PokeApiService();

  Future<List<PokemonListItem>> getPokemonList({int offset = 0, int limit = 50}) async {
    return await apiService.fetchPokemonList(offset: offset, limit: limit);
  }

  Future<PokemonDetail> getPokemonDetail(int id) async {
    return await apiService.fetchPokemonDetail(id);
  }
}
