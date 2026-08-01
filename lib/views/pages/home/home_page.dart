import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> mockPokemon = const [
    {'id': '1', 'name': 'Bulbasaur', 'type': 'Grass / Poison'},
    {'id': '4', 'name': 'Charmander', 'type': 'Fire'},
    {'id': '7', 'name': 'Squirtle', 'type': 'Water'},
    {'id': '25', 'name': 'Pikachu', 'type': 'Electric'},
    {'id': '150', 'name': 'Mewtwo', 'type': 'Psychic'},
    {'id': '133', 'name': 'Eevee', 'type': 'Normal'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Explorer'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockPokemon.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final poke = mockPokemon[index];
          return ShadCard(
            title: Text('#${poke['id']} ${poke['name']}'),
            description: Text(poke['type']!),
            footer: ShadButton.outline(
              size: ShadButtonSize.sm,
              child: const Text('View Details'),
              onPressed: () => context.go('/home/detail/${poke['id']}'),
            ),
          );
        },
      ),
    );
  }
}
