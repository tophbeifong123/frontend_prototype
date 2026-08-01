import 'package:equatable/equatable.dart';
import '../../models/pokemon.dart';

abstract class PokemonDetailState extends Equatable {
  const PokemonDetailState();

  @override
  List<Object?> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final PokemonDetail detail;

  const PokemonDetailLoaded({required this.detail});

  @override
  List<Object?> get props => [detail];
}

class PokemonDetailError extends PokemonDetailState {
  final String message;

  const PokemonDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
