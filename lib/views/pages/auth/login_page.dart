import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginSubmitted() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('Authentication Error'),
          description: const Text('Please provide both email and password.'),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthLoginRequested(username: email, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/home');
          } else if (state is AuthFailure) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Login Failed'),
                description: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: ShadCard(
                  title: const Text('Welcome Back'),
                  description: const Text('Sign in to your Pokémon Trainer account'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ShadInput(
                          controller: _emailController,
                          placeholder: const Text('Email address'),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !isLoading,
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(LucideIcons.mail, size: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ShadInput(
                          controller: _passwordController,
                          placeholder: const Text('Password'),
                          obscureText: true,
                          enabled: !isLoading,
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(LucideIcons.lock, size: 18),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ShadButton(
                          onPressed: isLoading ? null : _onLoginSubmitted,
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ShadButton.ghost(
                            onPressed: isLoading ? null : () => context.go('/register'),
                            child: const Text("Don't have an account? Register"),
                          ),
                        ),
                      ],
                    ),
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
