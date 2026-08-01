import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemonList extends PokemonEvent {
  final int offset;
  final int limit;

  const FetchPokemonList({this.offset = 0, this.limit = 50});

  @override
  List<Object?> get props => [offset, limit];
}

class FetchPokemonDetail extends PokemonEvent {
  final int id;

  const FetchPokemonDetail({required this.id});

  @override
  List<Object?> get props => [id];
}
