import 'package:equatable/equatable.dart';
import '../../models/pokemon.dart';

abstract class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object?> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  final List<PokemonListItem> pokemonList;

  const PokemonListLoaded({required this.pokemonList});

  @override
  List<Object?> get props => [pokemonList];
}

class PokemonListError extends PokemonListState {
  final String message;

  const PokemonListError({required this.message});

  @override
  List<Object?> get props => [message];
}
