import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/pokemon_detail/pokemon_detail_bloc.dart';
import '../../../blocs/pokemon_detail/pokemon_detail_event.dart';
import '../../../blocs/pokemon_detail/pokemon_detail_state.dart';
import '../../../core/utils/pokemon_type_helper.dart';
import '../../../models/pokemon.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/stat_progress_bar.dart';

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
    context.read<PokemonDetailBloc>().add(FetchPokemonDetail(id: widget.pokemonId));
  }

  @override
  void didUpdateWidget(covariant DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pokemonId != widget.pokemonId) {
      context.read<PokemonDetailBloc>().add(FetchPokemonDetail(id: widget.pokemonId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${widget.pokemonId.toString().padLeft(3, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFFEAF1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF1F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Pokémon $formattedId Details',
          style: const TextStyle(
            color: Color(0xFF0A1C2C),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0A1C2C), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
        builder: (context, state) {
          if (state is PokemonDetailLoading || state is PokemonDetailInitial) {
            return const LoadingIndicator(message: 'Fetching Pokémon details...');
          }

          if (state is PokemonDetailError) {
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
            final primaryType = detail.types.isNotEmpty ? detail.types.first : 'normal';
            final typeInfo = PokemonTypeHelper.getTypeInfo(primaryType);
            final pastelColor = typeInfo.pastelBackgroundColor;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Hero Card (Nintendo Switch Pastel Inspired)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: pastelColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.8),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0A1C2C).withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Pure Background PokéBall Watermark
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Transform.translate(
                                      offset: const Offset(45, 0),
                                      child: Icon(
                                        Icons.catching_pokemon,
                                        size: 260,
                                        color: Colors.black.withValues(alpha: 0.04),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Card Content Foreground
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                child: Column(
                                  children: [
                                    // Large Prominent Floating Artwork Image
                                    SizedBox(
                                      height: 230,
                                      child: Center(
                                        child: Image.network(
                                          detail.imageUrl,
                                          height: 230,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const SizedBox(
                                              height: 230,
                                              child: Center(child: CircularProgressIndicator()),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) => const Icon(
                                            Icons.catching_pokemon,
                                            size: 120,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      formattedDetailId,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF5A6E7F),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      detail.name.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0A1C2C),
                                        letterSpacing: 0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    // Solid Type Badges matching PokemonTypeHelper
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      alignment: WrapAlignment.center,
                                      children: detail.types.map((typeStr) {
                                        final info = PokemonTypeHelper.getTypeInfo(typeStr);
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 11,
                                            vertical: 5.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: info.color,
                                            borderRadius: BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(
                                                color: info.color.withValues(alpha: 0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(info.icon, size: 13, color: Colors.white),
                                              const SizedBox(width: 5),
                                              Text(
                                                info.displayName,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Physical Specs Card
                      _DetailCardSection(
                        title: 'Physical Specs',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SpecItem(
                              label: 'HEIGHT',
                              value: '${(detail.height / 10).toStringAsFixed(1)} m',
                              icon: Icons.height_rounded,
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFFD3E0EA),
                            ),
                            _SpecItem(
                              label: 'WEIGHT',
                              value: '${(detail.weight / 10).toStringAsFixed(1)} kg',
                              icon: Icons.scale_rounded,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Base Stats Card with Color Highlights
                      _DetailCardSection(
                        title: 'Base Stats',
                        child: Column(
                          children: detail.stats.entries.map((entry) {
                            return StatProgressBar(
                              label: entry.key,
                              value: entry.value,
                            );
                          }).toList(),
                        ),
                      ),

                      // Evolution Chain Section
                      if (detail.evolutions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _DetailCardSection(
                          title: 'Evolution Chain',
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isWideEnough =
                                  constraints.maxWidth >= (detail.evolutions.length * 105);

                              Widget content = Row(
                                mainAxisAlignment: isWideEnough
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                                mainAxisSize: isWideEnough
                                    ? MainAxisSize.min
                                    : MainAxisSize.max,
                                children: [
                                  for (int i = 0; i < detail.evolutions.length; i++) ...[
                                    if (i > 0)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Color(0xFF8A9BA8),
                                        ),
                                      ),
                                    _EvolutionStageCard(
                                      evolution: detail.evolutions[i],
                                      isCurrent: detail.evolutions[i].id == detail.id,
                                    ),
                                  ],
                                ],
                              );

                              if (!isWideEnough) {
                                content = SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: content,
                                );
                              }

                              return Center(child: content);
                            },
                          ),
                        ),
                      ],
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

class _DetailCardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailCardSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A1C2C),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SpecItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF5A6E7F)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A6E7F),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A1C2C),
          ),
        ),
      ],
    );
  }
}

class _EvolutionStageCard extends StatelessWidget {
  final PokemonEvolution evolution;
  final bool isCurrent;

  const _EvolutionStageCard({
    required this.evolution,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${evolution.id.toString().padLeft(3, '0')}';
    const activeColor = Color(0xFF0C60A1);

    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? activeColor : const Color(0xFFD3E0EA),
          width: isCurrent ? 2 : 1,
        ),
        color: isCurrent
            ? const Color(0xFF0C60A1).withValues(alpha: 0.08)
            : const Color(0xFFF8FAFC),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            evolution.imageUrl,
            height: 56,
            width: 56,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.catching_pokemon,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedId,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5A6E7F),
            ),
          ),
          Text(
            evolution.name.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
              color: isCurrent ? activeColor : const Color(0xFF0A1C2C),
            ),
          ),
        ],
      ),
    );
  }
}
