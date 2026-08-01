import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pokemon_repository.dart';
import 'pokemon_list_event.dart';
import 'pokemon_list_state.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository pokemonRepository;

  PokemonListBloc({required this.pokemonRepository}) : super(PokemonListInitial()) {
    on<FetchPokemonList>(_onFetchList);
  }

  Future<void> _onFetchList(
    FetchPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    // Only emit loading if list is empty to prevent UI flicker on refresh
    if (state is! PokemonListLoaded) {
      emit(PokemonListLoading());
    }

    try {
      final list = await pokemonRepository.getPokemonList(
        offset: event.offset,
        limit: event.limit,
      );
      emit(PokemonListLoaded(pokemonList: list));
    } catch (e) {
      emit(PokemonListError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
