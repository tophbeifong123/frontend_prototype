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
      backgroundColor: const Color(0xFFEAF1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF1F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Search Pokédex',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A1C2C),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0A1C2C),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search for a type or Pokémon...',
                hintStyle: const TextStyle(
                  color: Color(0xFF8A9BA8),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF0C60A1),
                  size: 22,
                ),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0A1C2C),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose a type to start filtering Pokémon.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5A6E7F),
              ),
            ),
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
