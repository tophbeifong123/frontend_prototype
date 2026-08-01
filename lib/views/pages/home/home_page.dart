import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/pokemon/pokemon_bloc.dart';
import '../../../blocs/pokemon/pokemon_event.dart';
import '../../../blocs/pokemon/pokemon_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(const FetchPokemonList(offset: 0, limit: 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex Explorer'),
        centerTitle: false,
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading || state is PokemonInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PokemonError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load Pokémon list',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                    const SizedBox(height: 16),
                    ShadButton(
                      child: const Text('Retry'),
                      onPressed: () {
                        context.read<PokemonBloc>().add(const FetchPokemonList(offset: 0, limit: 50));
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PokemonListLoaded) {
            final list = state.pokemonList;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PokemonBloc>().add(const FetchPokemonList(offset: 0, limit: 50));
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final formattedId = '#${item.id.toString().padLeft(3, '0')}';

                  return GestureDetector(
                    onTap: () => context.push('/home/detail/${item.id}'),
                    child: ShadCard(
                      title: Text(
                        '$formattedId ${item.name.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      child: Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Image.network(
                              item.imageUrl,
                              height: 100,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.catching_pokemon,
                                size: 64,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
