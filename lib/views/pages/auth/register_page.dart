import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ShadCard(
              title: const Text('Trainer Registration'),
              description: const Text('Create your account to start catching Pokémon'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ShadInput(
                      placeholder: Text('Full Name'),
                    ),
                    const SizedBox(height: 16),
                    const ShadInput(
                      placeholder: Text('Email'),
                    ),
                    const SizedBox(height: 16),
                    const ShadInput(
                      placeholder: Text('Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ShadButton(
                      child: const Text('Register'),
                      onPressed: () => context.go('/home'),
                    ),
                    const SizedBox(height: 12),
                    ShadButton.ghost(
                      child: const Text('Already have an account? Sign In'),
                      onPressed: () => context.go('/login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
