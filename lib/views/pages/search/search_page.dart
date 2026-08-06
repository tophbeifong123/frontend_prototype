import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/pokemon.dart';
import '../../../repositories/pokemon_repository.dart';
import 'widgets/search_filter_bar.dart';
import 'widgets/search_pokemon_results.dart';
import 'widgets/search_type_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final Set<String> _selectedTypes = <String>{};
  Future<List<PokemonListItem>>? _pokemonFuture;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<PokemonListItem>> _loadPokemon() {
    final repository = context.read<PokemonRepository>();
    final selectedTypes = _selectedTypes.toList();
    return selectedTypes.isEmpty
        ? repository.getPokemonList()
        : repository.getPokemonByTypes(selectedTypes);
  }

  void _selectInitialType(String type) {
    setState(() {
      _selectedTypes.add(type);
      _pokemonFuture = _loadPokemon();
    });
  }

  void _toggleType(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
      _pokemonFuture = _selectedTypes.isEmpty ? null : _loadPokemon();
    });
  }

  void _removeType(String type) {
    setState(() {
      _selectedTypes.remove(type);
      _pokemonFuture = _selectedTypes.isEmpty ? null : _loadPokemon();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value.trim().toLowerCase();
      if (_query.isNotEmpty && _pokemonFuture == null) {
        _pokemonFuture = _loadPokemon();
      }
      if (_query.isEmpty && _selectedTypes.isEmpty) {
        _pokemonFuture = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFilters = _selectedTypes.isNotEmpty;
    final showResults = hasFilters || _query.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Search Pokémon')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search for a type or Pokémon...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (hasFilters) ...[
            const SizedBox(height: 12),
            TypeFilterBar(
              selectedTypes: _selectedTypes.toList(),
              onRemove: _removeType,
              onToggle: _toggleType,
            ),
          ],
          const SizedBox(height: 20),
          if (showResults)
            PokemonResults(
              future: _pokemonFuture ?? _loadPokemon(),
              query: _query,
              hasFilters: hasFilters,
              onClear: hasFilters
                  ? () => setState(() {
                        _selectedTypes.clear();
                        _pokemonFuture = _query.isEmpty ? null : _loadPokemon();
                      })
                  : null,
              onRetry: () => setState(() => _pokemonFuture = _loadPokemon()),
            )
          else ...[
            const Text(
              'Explore Elemental Powers',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text('Choose a type to start filtering Pokémon.'),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 5;
                } else if (constraints.maxWidth >= 800) {
                  crossAxisCount = 4;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 3;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: typeOptions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) => TypeSearchCard(
                    option: typeOptions[index],
                    onTap: () => _selectInitialType(typeOptions[index].name),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
