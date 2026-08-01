import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon #$id Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ShadCard(
              title: Text('Pokémon Spec Sheet (#$id)'),
              description: const Text('Fetched from PokéAPI (https://pokeapi.co/api/v2/pokemon)'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: ShadTheme.of(context).colorScheme.muted,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#$id',
                        style: ShadTheme.of(context).textTheme.h2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShadBadge(
                    child: Text('PokéAPI ID: $id'),
                  ),
                  const SizedBox(height: 24),
                  ShadButton(
                    child: const Text('Back to Home'),
                    onPressed: () => context.go('/home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
