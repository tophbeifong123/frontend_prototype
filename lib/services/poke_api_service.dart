import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

/// Low-level service for interacting directly with the PokéAPI REST endpoints.
class PokeApiService {
  final http.Client client;
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  PokeApiService({http.Client? client}) : client = client ?? http.Client();

  /// Raw request to fetch Pokémon list JSON
  Future<List<PokemonListItem>> fetchPokemonList({int limit = 30, int offset = 0}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] as List<dynamic>;
      return results
          .map((item) => PokemonListItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch Pokémon list (${response.statusCode})');
    }
  }

  /// Raw request to fetch detailed Pokémon JSON by ID or Name
  Future<PokemonDetail> fetchPokemonDetail(String idOrName) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon/$idOrName'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      throw Exception('Failed to fetch Pokémon detail for $idOrName (${response.statusCode})');
    }
  }
}
