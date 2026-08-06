library;

/// Data models for PokéAPI integration.

class PokemonListItem {
  final int id;
  final String name;
  final String url;
  final String imageUrl;

  PokemonListItem({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final String urlStr = json['url'] as String;
    final Uri uri = Uri.parse(urlStr);
    final List<String> segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final int parsedId = int.tryParse(segments.last) ?? 1;

    final String artworkUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$parsedId.png';

    return PokemonListItem(
      id: parsedId,
      name: json['name'] as String,
      url: urlStr,
      imageUrl: artworkUrl,
    );
  }
}

class PokemonEvolution {
  final int id;
  final String name;
  final String imageUrl;

  PokemonEvolution({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final Map<String, int> stats;
  final String imageUrl;
  final List<PokemonEvolution> evolutions;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    required this.imageUrl,
    this.evolutions = const [],
  });

  factory PokemonDetail.fromJson(
    Map<String, dynamic> json, {
    List<PokemonEvolution> evolutions = const [],
  }) {
    final int pokeId = json['id'] as int;

    final List<String> typesList = (json['types'] as List<dynamic>)
        .map((t) => (t['type'] as Map<String, dynamic>)['name'] as String)
        .toList();

    final Map<String, int> statsMap = {};
    for (final s in (json['stats'] as List<dynamic>)) {
      final statName = (s['stat'] as Map<String, dynamic>)['name'] as String;
      final baseStat = s['base_stat'] as int;
      statsMap[statName] = baseStat;
    }

    final String officialArtworkUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokeId.png';

    return PokemonDetail(
      id: pokeId,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: typesList,
      stats: statsMap,
      imageUrl: officialArtworkUrl,
      evolutions: evolutions,
    );
  }
}
