import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ShadCard(
              title: const Text('Welcome Back'),
              description: const Text('Sign in to your Pokémon Trainer account'),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ShadInput(
                      placeholder: Text('Email / Username'),
                    ),
                    const SizedBox(height: 16),
                    const ShadInput(
                      placeholder: Text('Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    ShadButton(
                      child: const Text('Login'),
                      onPressed: () => context.go('/home'),
                    ),
                    const SizedBox(height: 12),
                    ShadButton.outline(
                      child: const Text('Create Account'),
                      onPressed: () => context.go('/register'),
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
