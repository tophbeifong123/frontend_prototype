import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../models/pokemon.dart';
import '../../../services/poke_api_service.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PokeApiService _apiService = PokeApiService();
  late Future<PokemonDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _apiService.fetchPokemonDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon #${widget.id} Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: FutureBuilder<PokemonDetail>(
        future: _detailFuture,
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
                      'Failed to load details for #${widget.id}',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 16),
                    ShadButton(
                      child: const Text('Back to Home'),
                      onPressed: () => context.go('/home'),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ShadCard(
                  title: Text(
                    detail.name.toUpperCase(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  description: Text('PokéAPI Index: #${detail.id}'),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Image.network(
                          detail.imageUrl,
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.catching_pokemon, size: 100),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: detail.types
                            .map((t) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: ShadBadge(
                                    child: Text(t.toUpperCase()),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('Height', style: ShadTheme.of(context).textTheme.muted),
                              const SizedBox(height: 4),
                              Text('${detail.height / 10} m', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Weight', style: ShadTheme.of(context).textTheme.muted),
                              const SizedBox(height: 4),
                              Text('${detail.weight / 10} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Base Stats',
                          style: ShadTheme.of(context).textTheme.h4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...detail.stats.map(
                        (stat) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  stat.name.toUpperCase(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (stat.baseStat / 255).clamp(0.0, 1.0),
                                  backgroundColor: Colors.grey.shade800,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${stat.baseStat}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ShadButton.outline(
                        child: const Text('Back to Home'),
                        onPressed: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
