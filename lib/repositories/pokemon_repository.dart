import '../models/pokemon.dart';
import '../services/poke_api_service.dart';

/// Repository for Pokémon data abstraction.
class PokemonRepository {
  final PokeApiService apiService;

  PokemonRepository({PokeApiService? apiService})
      : apiService = apiService ?? PokeApiService();

  Future<List<PokemonListItem>> getPokemonList({int limit = 30, int offset = 0}) async {
    return await apiService.fetchPokemonList(limit: limit, offset: offset);
  }

  Future<PokemonDetail> getPokemonDetail(String idOrName) async {
    return await apiService.fetchPokemonDetail(idOrName);
  }
}
