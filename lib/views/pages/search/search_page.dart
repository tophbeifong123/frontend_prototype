import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../models/pokemon.dart';
import '../../../repositories/pokemon_repository.dart';
import '../../widgets/pokemon_card.dart';

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
            _TypeFilterBar(
              selectedTypes: _selectedTypes.toList(),
              onRemove: _removeType,
              onToggle: _toggleType,
            ),
          ],
          const SizedBox(height: 20),
          if (showResults)
            _PokemonResults(
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _typeOptions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) => _TypeSearchCard(
                option: _typeOptions[index],
                onTap: () => _selectInitialType(_typeOptions[index].name),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PokemonResults extends StatelessWidget {
  const _PokemonResults({
    required this.future,
    required this.query,
    required this.hasFilters,
    required this.onClear,
    required this.onRetry,
  });

  final Future<List<PokemonListItem>> future;
  final String query;
  final bool hasFilters;
  final VoidCallback? onClear;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<PokemonListItem>>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(Icons.cloud_off_outlined, size: 48),
                const SizedBox(height: 12),
                const Text('Could not load Pokémon.'),
                TextButton(onPressed: onRetry, child: const Text('Try again')),
              ],
            ),
          ),
        );
      }
      if (!snapshot.hasData) {
        return const Padding(
          padding: EdgeInsets.all(36),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final pokemon = snapshot.data!
          .where((item) => query.isEmpty || item.name.contains(query))
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hasFilters ? 'Matching Pokémon' : 'Search results',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (onClear != null)
                TextButton(onPressed: onClear, child: const Text('Clear all')),
            ],
          ),
          const SizedBox(height: 8),
          if (pokemon.isEmpty)
            const Padding(
              padding: EdgeInsets.all(36),
              child: Center(child: Text('No Pokémon found.')),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pokemon.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .82,
              ),
              itemBuilder: (context, index) {
                final item = pokemon[index];
                return FavoritePokemonCard(
                  pokemon: item,
                  onTap: () => context.push('/home/detail/${item.id}'),
                );
              },
            ),
        ],
      );
    },
  );
}

class _TypeSearchOption {
  const _TypeSearchOption(this.name, this.count);
  final String name;
  final int count;
}

const _typeOptions = [
  _TypeSearchOption('fire', 72),
  _TypeSearchOption('water', 133),
  _TypeSearchOption('electric', 54),
  _TypeSearchOption('grass', 102),
  _TypeSearchOption('psychic', 82),
  _TypeSearchOption('ghost', 46),
  _TypeSearchOption('ice', 38),
  _TypeSearchOption('dragon', 50),
  _TypeSearchOption('steel', 60),
  _TypeSearchOption('normal', 125),
  _TypeSearchOption('fighting', 78),
  _TypeSearchOption('poison', 92),
  _TypeSearchOption('ground', 78),
  _TypeSearchOption('flying', 105),
  _TypeSearchOption('bug', 86),
  _TypeSearchOption('rock', 75),
  _TypeSearchOption('dark', 55),
  _TypeSearchOption('fairy', 70),
];

class _TypeSearchCard extends StatelessWidget {
  const _TypeSearchCard({required this.option, required this.onTap});
  final _TypeSearchOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(option.name);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('type-${option.name}'),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: Icon(_typeIcon(option.name), color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                _displayType(option.name),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                '${option.count} Pokémon',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeFilterBar extends StatelessWidget {
  const _TypeFilterBar({
    required this.selectedTypes,
    required this.onRemove,
    required this.onToggle,
  });

  final List<String> selectedTypes;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ...selectedTypes.map(
          (type) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _SelectedTypeChip(
              type: type,
              onRemove: () => onRemove(type),
            ),
          ),
        ),
        _AddTypeMenu(selectedTypes: selectedTypes, onToggle: onToggle),
      ],
    ),
  );
}

class _AddTypeMenu extends StatefulWidget {
  const _AddTypeMenu({required this.selectedTypes, required this.onToggle});
  final List<String> selectedTypes;
  final ValueChanged<String> onToggle;

  @override
  State<_AddTypeMenu> createState() => _AddTypeMenuState();
}

class _AddTypeMenuState extends State<_AddTypeMenu> {
  final _menuController = MenuController();

  @override
  Widget build(BuildContext context) => MenuAnchor(
    controller: _menuController,
    menuChildren: [
      SizedBox(
        width: 200,
        height: 276,
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.zero,
          itemCount: _typeOptions.length,
          itemBuilder: (context, index) {
            final option = _typeOptions[index];
            final selected = widget.selectedTypes.contains(option.name);
            final color = _typeColor(option.name);
            return InkWell(
              key: ValueKey('add-type-${option.name}'),
              onTap: () {
                widget.onToggle(option.name);
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    Icon(_typeIcon(option.name), color: color, size: 19),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_displayType(option.name))),
                    Icon(
                      selected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
    builder: (context, controller, child) => OutlinedButton.icon(
      key: const ValueKey('add-type-filter'),
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      icon: const Icon(Icons.add_circle_outline, size: 18),
      label: const Text('Add'),
    ),
  );
}

class _SelectedTypeChip extends StatelessWidget {
  const _SelectedTypeChip({required this.type, required this.onRemove});
  final String type;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(type);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 12),
          Icon(_typeIcon(type), size: 17, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            _displayType(type),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            key: ValueKey('remove-type-$type'),
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 17),
            color: Colors.white,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

String _displayType(String type) => type[0].toUpperCase() + type.substring(1);

Color _typeColor(String type) => switch (type) {
  'fire' => const Color(0xffef5350),
  'water' => const Color(0xff42a5f5),
  'grass' => const Color(0xff66bb6a),
  'electric' => const Color(0xffffca28),
  'psychic' => const Color(0xffec407a),
  'ice' => const Color(0xff26c6da),
  'dragon' => const Color(0xff5c6bc0),
  'ghost' => const Color(0xff7e57c2),
  'steel' => const Color(0xff78909c),
  _ => const Color(0xff8d99a6),
};

IconData _typeIcon(String type) => switch (type) {
  'fire' => Icons.local_fire_department,
  'water' => Icons.water_drop,
  'grass' => Icons.eco,
  'electric' => Icons.bolt,
  'psychic' => Icons.visibility,
  'ice' => Icons.ac_unit,
  'ghost' => Icons.nightlight_round,
  'dragon' => Icons.pets,
  'flying' => Icons.air,
  _ => Icons.category,
};
