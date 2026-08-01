import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pokemon_repository.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository pokemonRepository;

  PokemonBloc({required this.pokemonRepository}) : super(PokemonInitial()) {
    on<FetchPokemonList>(_onFetchList);
    on<FetchPokemonDetail>(_onFetchDetail);
  }

  Future<void> _onFetchList(
    FetchPokemonList event,
    Emitter<PokemonState> emit,
  ) async {
    emit(PokemonLoading());
    try {
      final list = await pokemonRepository.getPokemonList(
        offset: event.offset,
        limit: event.limit,
      );
      emit(PokemonListLoaded(pokemonList: list));
    } catch (e) {
      emit(PokemonError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFetchDetail(
    FetchPokemonDetail event,
    Emitter<PokemonState> emit,
  ) async {
    emit(PokemonLoading());
    try {
      final detail = await pokemonRepository.getPokemonDetail(event.id);
      emit(PokemonDetailLoaded(detail: detail));
    } catch (e) {
      emit(PokemonError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
