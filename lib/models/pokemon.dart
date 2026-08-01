library;

/// Data models for PokéAPI integration.

class PokemonListItem {
  final int id;
  final String name;
  final String url;

  PokemonListItem({
    required this.id,
    required this.name,
    required this.url,
  });

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final String urlStr = json['url'] as String;
    // Extract ID from URL (e.g., https://pokeapi.co/api/v2/pokemon/1/)
    final Uri uri = Uri.parse(urlStr);
    final List<String> segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final int parsedId = int.tryParse(segments.last) ?? 1;

    return PokemonListItem(
      id: parsedId,
      name: json['name'] as String,
      url: urlStr,
    );
  }
}

class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({required this.name, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: (json['stat'] as Map<String, dynamic>)['name'] as String,
      baseStat: json['base_stat'] as int,
    );
  }
}

class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final List<String> types;
  final List<PokemonStat> stats;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final typesList = (json['types'] as List<dynamic>)
        .map((t) => (t['type'] as Map<String, dynamic>)['name'] as String)
        .toList();

    final statsList = (json['stats'] as List<dynamic>)
        .map((s) => PokemonStat.fromJson(s as Map<String, dynamic>))
        .toList();

    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final officialArtwork = other?['official-artwork'] as Map<String, dynamic>?;
    final String spriteUrl = officialArtwork?['front_default'] as String? ??
        sprites['front_default'] as String? ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$json["id"].png';

    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      imageUrl: spriteUrl,
      types: typesList,
      stats: statsList,
    );
  }
}
