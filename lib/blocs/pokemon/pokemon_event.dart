import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemonList extends PokemonEvent {
  final int limit;
  final int offset;

  const FetchPokemonList({this.limit = 30, this.offset = 0});

  @override
  List<Object?> get props => [limit, offset];
}

class FetchPokemonDetail extends PokemonEvent {
  final String idOrName;

  const FetchPokemonDetail({required this.idOrName});

  @override
  List<Object?> get props => [idOrName];
}
