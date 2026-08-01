import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemonList extends PokemonListEvent {
  final int offset;
  final int limit;

  const FetchPokemonList({this.offset = 0, this.limit = 50});

  @override
  List<Object?> get props => [offset, limit];
}
