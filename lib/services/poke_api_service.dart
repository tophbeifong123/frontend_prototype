import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

/// Network service handling HTTP requests to the official PokéAPI.
class PokeApiService {
  final http.Client client;
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  PokeApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches a paginated list of Pokémon items.
  Future<List<PokemonListItem>> fetchPokemonList({
    int offset = 0,
    int limit = 50,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon?offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> results = body['results'] as List<dynamic>;
      return results
          .map((item) => PokemonListItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'HTTP Error ${response.statusCode}: Failed to fetch Pokémon list',
      );
    }
  }

  /// Fetches Pokémon for several types using OR semantics and removes duplicates.
  Future<List<PokemonListItem>> fetchPokemonByTypes(List<String> types) async {
    if (types.isEmpty) return fetchPokemonList();

    final groups = await Future.wait(types.map(fetchPokemonByType));
    final unique = <int, PokemonListItem>{
      for (final pokemon in groups.expand((group) => group))
        pokemon.id: pokemon,
    };
    final result = unique.values.toList()..sort((a, b) => a.id.compareTo(b.id));
    return result;
  }

  Future<List<PokemonListItem>> fetchPokemonByType(String type) async {
    final response = await client.get(Uri.parse('$baseUrl/type/$type'));
    if (response.statusCode != 200) {
      throw Exception(
        'HTTP Error ${response.statusCode}: Failed to fetch $type Pokémon',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final entries = body['pokemon'] as List<dynamic>;
    return entries
        .map((entry) => entry['pokemon'] as Map<String, dynamic>)
        .map(PokemonListItem.fromJson)
        .toList();
  }

  /// Fetches evolution chain for a Pokémon.
  Future<List<PokemonEvolution>> fetchEvolutionsForPokemon(int pokeId) async {
    try {
      final speciesRes = await client.get(
        Uri.parse('$baseUrl/pokemon-species/$pokeId'),
      );
      if (speciesRes.statusCode != 200) return [];

      final speciesBody = jsonDecode(speciesRes.body) as Map<String, dynamic>;
      final evoChainObj = speciesBody['evolution_chain'] as Map<String, dynamic>?;
      if (evoChainObj == null || evoChainObj['url'] == null) return [];

      final evoRes = await client.get(Uri.parse(evoChainObj['url'] as String));
      if (evoRes.statusCode != 200) return [];

      final evoBody = jsonDecode(evoRes.body) as Map<String, dynamic>;
      final chain = evoBody['chain'] as Map<String, dynamic>?;
      if (chain == null) return [];

      final List<PokemonEvolution> list = [];
      void traverse(Map<String, dynamic> node) {
        final species = node['species'] as Map<String, dynamic>?;
        if (species != null) {
          final urlStr = species['url'] as String;
          final uri = Uri.parse(urlStr);
          final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
          final parsedId = int.tryParse(segments.last) ?? 1;
          final name = species['name'] as String;
          final artwork =
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$parsedId.png';
          list.add(PokemonEvolution(id: parsedId, name: name, imageUrl: artwork));
        }
        final evolvesTo = node['evolves_to'] as List<dynamic>?;
        if (evolvesTo != null) {
          for (final child in evolvesTo) {
            traverse(child as Map<String, dynamic>);
          }
        }
      }

      traverse(chain);
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Fetches comprehensive details including evolution chain for a specific Pokémon.
  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    final detailFuture = client.get(Uri.parse('$baseUrl/pokemon/$id'));
    final evolutionsFuture = fetchEvolutionsForPokemon(id);

    final response = await detailFuture;

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final evolutions = await evolutionsFuture;
      return PokemonDetail.fromJson(body, evolutions: evolutions);
    } else {
      throw Exception(
        'HTTP Error ${response.statusCode}: Failed to fetch details for Pokémon #$id',
      );
    }
  }
}
