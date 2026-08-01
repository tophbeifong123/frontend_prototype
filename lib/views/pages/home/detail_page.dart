import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/pokemon/pokemon_bloc.dart';
import '../../../blocs/pokemon/pokemon_event.dart';
import '../../../blocs/pokemon/pokemon_state.dart';

class DetailPage extends StatefulWidget {
  final int pokemonId;

  const DetailPage({super.key, required this.pokemonId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(FetchPokemonDetail(id: widget.pokemonId));
  }

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${widget.pokemonId.toString().padLeft(3, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon $formattedId Details'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
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
                      'Failed to load details for $formattedId',
                      style: ShadTheme.of(context).textTheme.h4,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                    const SizedBox(height: 16),
                    ShadButton(
                      child: const Text('Back'),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PokemonDetailLoaded) {
            final detail = state.detail;
            final formattedDetailId = '#${detail.id.toString().padLeft(3, '0')}';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 550),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header: Large official artwork image and Pokémon Name
                      Center(
                        child: Column(
                          children: [
                            Image.network(
                              detail.imageUrl,
                              height: 200,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  height: 200,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.catching_pokemon,
                                size: 120,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$formattedDetailId ${detail.name.toUpperCase()}',
                              style: ShadTheme.of(context).textTheme.h2,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            // Badges: Show element types using ShadBadge
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: detail.types
                                  .map((type) => ShadBadge(
                                        child: Text(type.toUpperCase()),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Specs Card: Height (m) and Weight (kg)
                      ShadCard(
                        title: const Text('Physical Specs'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Height',
                                    style: ShadTheme.of(context).textTheme.muted,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(detail.height / 10).toStringAsFixed(1)} m',
                                    style: ShadTheme.of(context).textTheme.h4,
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 36,
                                color: ShadTheme.of(context).colorScheme.border,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Weight',
                                    style: ShadTheme.of(context).textTheme.muted,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(detail.weight / 10).toStringAsFixed(1)} kg',
                                    style: ShadTheme.of(context).textTheme.h4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Base Stats Card: Label + Score + Progress bar
                      ShadCard(
                        title: const Text('Base Stats'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: detail.stats.entries.map((entry) {
                              final double progress = (entry.value / 255).clamp(0.0, 1.0);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        entry.key.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 8,
                                          backgroundColor:
                                              ShadTheme.of(context).colorScheme.muted,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            ShadTheme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 32,
                                      child: Text(
                                        '${entry.value}',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
