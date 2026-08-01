import 'package:equatable/equatable.dart';

abstract class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemonDetail extends PokemonDetailEvent {
  final int id;

  const FetchPokemonDetail({required this.id});

  @override
  List<Object?> get props => [id];
}
