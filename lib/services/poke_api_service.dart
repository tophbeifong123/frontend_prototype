import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

/// HTTP Client Service for PokéAPI integration.
class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  /// Fetch list of Pokémon with pagination limit & offset
  Future<List<PokemonListItem>> fetchPokemonList({int limit = 30, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] as List<dynamic>;
      return results
          .map((item) => PokemonListItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Pokémon list from PokéAPI (${response.statusCode})');
    }
  }

  /// Fetch detailed information for a specific Pokémon by ID or name
  Future<PokemonDetail> fetchPokemonDetail(String idOrName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemon/$idOrName'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PokemonDetail.fromJson(data);
    } else {
      throw Exception('Failed to load Pokémon details for $idOrName (${response.statusCode})');
    }
  }
}
