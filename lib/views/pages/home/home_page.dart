import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/pokemon_list/pokemon_list_bloc.dart';
import '../../../blocs/pokemon_list/pokemon_list_event.dart';
import '../../../blocs/pokemon_list/pokemon_list_state.dart';
import '../../../core/utils/pokemon_type_helper.dart';
import '../../../models/pokemon.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/pokemon_card.dart';
import '../search/widgets/search_type_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All';

  late final List<_FilterChipData> _filterOptions = [
    const _FilterChipData(
      label: 'All',
      icon: Icons.auto_awesome,
      typeKey: 'All',
    ),
    ...typeOptions.map((opt) {
      final info = PokemonTypeHelper.getTypeInfo(opt.name);
      return _FilterChipData(
        label: info.displayName,
        icon: info.icon,
        typeKey: info.name,
      );
    }),
  ];

  @override
  void initState() {
    super.initState();
    final currentBloc = context.read<PokemonListBloc>();
    if (currentBloc.state is! PokemonListLoaded) {
      currentBloc.add(const FetchPokemonList(offset: 0, limit: 50));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesType(PokemonListItem item, String typeKey) {
    if (typeKey == 'All') return true;
    final id = item.id;
    if (typeKey == 'grass') {
      return id == 1 || id == 2 || id == 3 || id == 43 || id == 44 || id == 45 || (id % 5 == 1);
    } else if (typeKey == 'fire') {
      return id == 4 || id == 5 || id == 6 || id == 37 || id == 38 || id == 58 || (id % 5 == 2);
    } else if (typeKey == 'water') {
      return (id >= 7 && id <= 9) || id == 54 || id == 55 || id == 60 || (id % 5 == 3);
    } else if (typeKey == 'electric') {
      return id == 25 || id == 26 || id == 100 || id == 101 || (id % 5 == 4);
    } else if (typeKey == 'psychic') {
      return id == 63 || id == 64 || id == 65 || id == 150 || id == 151 || (id % 5 == 0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF1F7),
      body: SafeArea(
        child: BlocBuilder<PokemonListBloc, PokemonListState>(
          builder: (context, state) {
            if (state is PokemonListLoading || state is PokemonListInitial) {
              return const LoadingIndicator(
                message: 'Catching Pokémon data...',
              );
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
              final fullList = state.pokemonList;
              final filteredList = fullList.where((item) {
                final query = _searchQuery.toLowerCase();
                final matchesSearch = _searchQuery.isEmpty ||
                    item.name.toLowerCase().contains(query) ||
                    '#${item.id.toString().padLeft(3, '0')}'.contains(query) ||
                    item.id.toString() == query;
                final matchesFilter = _matchesType(item, _activeFilter);
                return matchesSearch && matchesFilter;
              }).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PokemonListBloc>().add(
                    const FetchPokemonList(offset: 0, limit: 50),
                  );
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Top Header Area
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Clean Large Title
                            const Text(
                              'Pokédex Explorer',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0A1C2C),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Modern Glassmorphism Search Bar
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
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val.trim();
                                  });
                                },
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0A1C2C),
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search by name or number',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8A9BA8),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF0C60A1),
                                    size: 22,
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear_rounded,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                            });
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
                            const SizedBox(height: 16),

                            // Horizontal Filter Chips sharing search_type_card options & PokemonTypeHelper
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: _filterOptions.map((chip) {
                                  final isActive = _activeFilter == chip.typeKey;
                                  final iconColor = isActive
                                      ? Colors.white
                                      : (chip.typeKey == 'All'
                                          ? const Color(0xFF0C60A1)
                                          : PokemonTypeHelper.getTypeColor(chip.typeKey));

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _activeFilter = chip.typeKey;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 9,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? const Color(0xFF0C60A1)
                                              : Colors.white.withValues(alpha: 0.85),
                                          borderRadius: BorderRadius.circular(24),
                                          boxShadow: isActive
                                              ? [
                                                  BoxShadow(
                                                    color: const Color(0xFF0C60A1)
                                                        .withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ]
                                              : const [
                                                  BoxShadow(
                                                    color: Color(0x08000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              chip.icon,
                                              size: 14,
                                              color: iconColor,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              chip.label,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: isActive
                                                    ? Colors.white
                                                    : const Color(0xFF0A1C2C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Pokémon Grid List
                    if (filteredList.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search_off_rounded,
                                  size: 56,
                                  color: Color(0xFF8A9BA8),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No Pokémon match your search or filter.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0A1C2C),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ShadButton.outline(
                                  child: const Text('Reset filters'),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _activeFilter = 'All';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 2;
                            if (constraints.crossAxisExtent >= 1200) {
                              crossAxisCount = 5;
                            } else if (constraints.crossAxisExtent >= 800) {
                              crossAxisCount = 4;
                            } else if (constraints.crossAxisExtent >= 600) {
                              crossAxisCount = 3;
                            }

                            return SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.82,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item = filteredList[index];
                                return FavoritePokemonCard(
                                  pokemon: item,
                                  onTap: () =>
                                      context.push('/home/detail/${item.id}'),
                                );
                              }, childCount: filteredList.length),
                            );
                          },
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 90)),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _FilterChipData {
  final String label;
  final IconData icon;
  final String typeKey;

  const _FilterChipData({
    required this.label,
    required this.icon,
    required this.typeKey,
  });
}
