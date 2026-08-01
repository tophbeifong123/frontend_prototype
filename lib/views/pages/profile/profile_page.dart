import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(LucideIcons.logOut),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.construction,
                size: 64,
                color: ShadTheme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Profile Dashboard Under Construction',
                style: ShadTheme.of(context).textTheme.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Trainer badge progress and custom avatar settings will be available soon!',
                style: ShadTheme.of(context).textTheme.muted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ShadButton.destructive(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                  context.go('/login');
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
