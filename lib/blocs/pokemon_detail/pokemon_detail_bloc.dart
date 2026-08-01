import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pokemon_repository.dart';
import 'pokemon_detail_event.dart';
import 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository pokemonRepository;

  PokemonDetailBloc({required this.pokemonRepository}) : super(PokemonDetailInitial()) {
    on<FetchPokemonDetail>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(
    FetchPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading());
    try {
      final detail = await pokemonRepository.getPokemonDetail(event.id);
      emit(PokemonDetailLoaded(detail: detail));
    } catch (e) {
      emit(PokemonDetailError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
