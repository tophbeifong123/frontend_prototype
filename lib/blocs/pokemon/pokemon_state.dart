import 'package:equatable/equatable.dart';
import '../../models/pokemon.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonListLoaded extends PokemonState {
  final List<PokemonListItem> pokemonList;

  const PokemonListLoaded({required this.pokemonList});

  @override
  List<Object?> get props => [pokemonList];
}

class PokemonDetailLoaded extends PokemonState {
  final PokemonDetail detail;

  const PokemonDetailLoaded({required this.detail});

  @override
  List<Object?> get props => [detail];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError({required this.message});

  @override
  List<Object?> get props => [message];
}
