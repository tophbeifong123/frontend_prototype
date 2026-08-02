import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/pokemon_list/pokemon_list_bloc.dart';
import '../../../blocs/pokemon_list/pokemon_list_event.dart';
import '../../../blocs/pokemon_list/pokemon_list_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/pokemon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Dispatch FetchPokemonList only if not already loaded
    final currentBloc = context.read<PokemonListBloc>();
    if (currentBloc.state is! PokemonListLoaded) {
      currentBloc.add(const FetchPokemonList(offset: 0, limit: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex Explorer'), centerTitle: false),
      body: BlocBuilder<PokemonListBloc, PokemonListState>(
        builder: (context, state) {
          if (state is PokemonListLoading || state is PokemonListInitial) {
            return const LoadingIndicator(message: 'Catching Pokémon data...');
          }

          if (state is PokemonListError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
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
                        context.read<PokemonListBloc>().add(
                          const FetchPokemonList(offset: 0, limit: 50),
                        );
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
                context.read<PokemonListBloc>().add(
                  const FetchPokemonList(offset: 0, limit: 50),
                );
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
                  return FavoritePokemonCard(
                    pokemon: item,
                    onTap: () => context.push('/home/detail/${item.id}'),
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
