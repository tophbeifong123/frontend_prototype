import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ShadCard(
              title: const Text('Ash Ketchum'),
              description: const Text('Pokémon Master in Training'),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ShadBadge(
                    child: const Text('Kanto Champion'),
                  ),
                  const SizedBox(height: 24),
                  ShadButton.destructive(
                    child: const Text('Sign Out'),
                    onPressed: () => context.go('/login'),
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
