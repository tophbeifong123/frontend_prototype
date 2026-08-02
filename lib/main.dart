import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'app/config/app_routes.dart';
import 'app/config/app_theme.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/favorites/favorites_cubit.dart';
import 'blocs/pokemon_detail/pokemon_detail_bloc.dart';
import 'blocs/pokemon_list/pokemon_list_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/pokemon_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<PokemonRepository>(
          create: (context) => PokemonRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<FavoritesCubit>(create: (context) => FavoritesCubit()),
          BlocProvider<PokemonListBloc>(
            create: (context) => PokemonListBloc(
              pokemonRepository: context.read<PokemonRepository>(),
            ),
          ),
          BlocProvider<PokemonDetailBloc>(
            create: (context) => PokemonDetailBloc(
              pokemonRepository: context.read<PokemonRepository>(),
            ),
          ),
        ],
        child: ShadApp.router(
          title: 'Pokémon App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
