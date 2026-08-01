import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../models/pokemon.dart';
import '../../../services/poke_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PokeApiService _apiService = PokeApiService();
  late Future<List<PokemonListItem>> _pokemonListFuture;

  @override
  void initState() {
    super.initState();
    _pokemonListFuture = _apiService.fetchPokemonList(limit: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Explorer'),
        elevation: 0,
      ),
      body: FutureBuilder<List<PokemonListItem>>(
        future: _pokemonListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load Pokémon',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                    const SizedBox(height: 16),
                    ShadButton(
                      child: const Text('Retry'),
                      onPressed: () {
                        setState(() {
                          _pokemonListFuture = _apiService.fetchPokemonList(limit: 30);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final list = snapshot.data ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final pokemon = list[index];
              return GestureDetector(
                onTap: () => context.go('/home/detail/${pokemon.id}'),
                child: ShadCard(
                  title: Text(
                    '#${pokemon.id} ${pokemon.name.toUpperCase()}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Image.network(
                          pokemon.imageUrl,
                          height: 90,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.catching_pokemon, size: 64),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
