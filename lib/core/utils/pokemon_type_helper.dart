import 'package:flutter/material.dart';

/// Single source of truth สำหรับประเภทธาตุ ไอคอน สีประจําธาตุ และสีพาสเทลของการ์ด Pokémon
/// Unified type palette & system icons helper.
class PokemonTypeInfo {
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  final Color pastelBackgroundColor;

  const PokemonTypeInfo({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    required this.pastelBackgroundColor,
  });
}

abstract class PokemonTypeHelper {
  static PokemonTypeInfo getTypeInfo(String typeName) {
    final lower = typeName.toLowerCase().trim();
    switch (lower) {
      case 'grass':
        return const PokemonTypeInfo(
          name: 'grass',
          displayName: 'Grass',
          icon: Icons.eco,
          color: Color(0xFF2E7D32),
          pastelBackgroundColor: Color(0xFFE0F2E9), // Mint Pastel
        );
      case 'fire':
        return const PokemonTypeInfo(
          name: 'fire',
          displayName: 'Fire',
          icon: Icons.local_fire_department,
          color: Color(0xFFD84315),
          pastelBackgroundColor: Color(0xFFFAEBE1), // Peach Pastel
        );
      case 'water':
        return const PokemonTypeInfo(
          name: 'water',
          displayName: 'Water',
          icon: Icons.water_drop,
          color: Color(0xFF1565C0),
          pastelBackgroundColor: Color(0xFFE0EFFB), // Sky Pastel
        );
      case 'electric':
        return const PokemonTypeInfo(
          name: 'electric',
          displayName: 'Electric',
          icon: Icons.bolt,
          color: Color(0xFFF57F17),
          pastelBackgroundColor: Color(0xFFFFF6D6), // Yellow Pastel
        );
      case 'psychic':
        return const PokemonTypeInfo(
          name: 'psychic',
          displayName: 'Psychic',
          icon: Icons.visibility,
          color: Color(0xFFC2185B),
          pastelBackgroundColor: Color(0xFFFCE4EC), // Pink Pastel
        );
      case 'poison':
        return const PokemonTypeInfo(
          name: 'poison',
          displayName: 'Poison',
          icon: Icons.science,
          color: Color(0xFF6A1B9A),
          pastelBackgroundColor: Color(0xFFF3E5F5),
        );
      case 'ice':
        return const PokemonTypeInfo(
          name: 'ice',
          displayName: 'Ice',
          icon: Icons.ac_unit,
          color: Color(0xFF00838F),
          pastelBackgroundColor: Color(0xFFE0F7FA),
        );
      case 'dragon':
        return const PokemonTypeInfo(
          name: 'dragon',
          displayName: 'Dragon',
          icon: Icons.pets,
          color: Color(0xFF283593),
          pastelBackgroundColor: Color(0xFFE8EAF6),
        );
      case 'ghost':
        return const PokemonTypeInfo(
          name: 'ghost',
          displayName: 'Ghost',
          icon: Icons.nightlight_round,
          color: Color(0xFF4A148C),
          pastelBackgroundColor: Color(0xFFEDE7F6),
        );
      case 'steel':
        return const PokemonTypeInfo(
          name: 'steel',
          displayName: 'Steel',
          icon: Icons.shield,
          color: Color(0xFF37474F),
          pastelBackgroundColor: Color(0xFFECEFF1),
        );
      case 'flying':
        return const PokemonTypeInfo(
          name: 'flying',
          displayName: 'Flying',
          icon: Icons.air,
          color: Color(0xFF0288D1),
          pastelBackgroundColor: Color(0xFFE1F5FE),
        );
      case 'bug':
        return const PokemonTypeInfo(
          name: 'bug',
          displayName: 'Bug',
          icon: Icons.bug_report,
          color: Color(0xFF558B2F),
          pastelBackgroundColor: Color(0xFFF1F8E9),
        );
      case 'rock':
        return const PokemonTypeInfo(
          name: 'rock',
          displayName: 'Rock',
          icon: Icons.landscape,
          color: Color(0xFF4E342E),
          pastelBackgroundColor: Color(0xFFEFEBE9),
        );
      case 'ground':
        return const PokemonTypeInfo(
          name: 'ground',
          displayName: 'Ground',
          icon: Icons.terrain,
          color: Color(0xFFBF360C),
          pastelBackgroundColor: Color(0xFFFBE9E7),
        );
      case 'fighting':
        return const PokemonTypeInfo(
          name: 'fighting',
          displayName: 'Fighting',
          icon: Icons.fitness_center,
          color: Color(0xFFB71C1C),
          pastelBackgroundColor: Color(0xFFFFEBEE),
        );
      case 'dark':
        return const PokemonTypeInfo(
          name: 'dark',
          displayName: 'Dark',
          icon: Icons.dark_mode,
          color: Color(0xFF212121),
          pastelBackgroundColor: Color(0xFFFAFAFA),
        );
      case 'fairy':
        return const PokemonTypeInfo(
          name: 'fairy',
          displayName: 'Fairy',
          icon: Icons.auto_awesome,
          color: Color(0xFFD81B60),
          pastelBackgroundColor: Color(0xFFFCE4EC),
        );
      default:
        return const PokemonTypeInfo(
          name: 'normal',
          displayName: 'Normal',
          icon: Icons.category,
          color: Color(0xFF5A6E7F),
          pastelBackgroundColor: Color(0xFFF0F3F6),
        );
    }
  }

  static IconData getTypeIcon(String typeName) => getTypeInfo(typeName).icon;
  static Color getTypeColor(String typeName) => getTypeInfo(typeName).color;
  static Color getPastelColor(String typeName) => getTypeInfo(typeName).pastelBackgroundColor;
  static String getDisplayName(String typeName) => getTypeInfo(typeName).displayName;
}
