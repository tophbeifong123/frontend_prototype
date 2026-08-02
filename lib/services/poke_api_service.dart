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

  /// Fetches comprehensive details for a specific Pokémon by ID.
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

  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/pokemon/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return PokemonDetail.fromJson(body);
    } else {
      throw Exception(
        'HTTP Error ${response.statusCode}: Failed to fetch details for Pokémon #$id',
      );
    }
  }
}
