import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

part 'home_state.dart';

/// Cubit for managing home page state (Pokemon list)
class HomeCubit extends Cubit<HomeState> {
  final PokemonRepository _pokemonRepository;
  Timer? _debounceTimer;

  HomeCubit(this._pokemonRepository)
    : super(
        HomeState(
          pokemonsLoadData: ViewData.initial(),
          pokemons: const [],
          filteredPokemons: const [],
          offset: 0,
          hasReachedMax: false,
          isLoadingMore: false,
          searchQuery: '',
        ),
      );

  /// Load initial Pokemon list
  Future<void> loadPokemons() async {
    if (state.pokemonsLoadData.isLoading) return;

    emit(
      state.copyWith(
        pokemonsLoadData: ViewData.loading(),
        offset: 0,
        hasReachedMax: false,
      ),
    );

    try {
      final result = await _pokemonRepository.getPokemons(
        offset: 0,
        limit: ApiConstants.defaultPageSize,
      );

      emit(
        state.copyWith(
          pokemonsLoadData: ViewData.loaded(data: result.pokemons),
          pokemons: result.pokemons,
          filteredPokemons: PokemonSearchHelper.filterPokemons(
            result.pokemons,
            state.searchQuery,
          ),
          offset: ApiConstants.defaultPageSize,
          hasReachedMax: !result.hasMore,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(pokemonsLoadData: ViewData.error(message: e.toString())),
      );
    }
  }

  /// Load more Pokemon (pagination)
  Future<void> loadMorePokemons() async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await _pokemonRepository.getPokemons(
        offset: state.offset,
        limit: ApiConstants.defaultPageSize,
      );

      final updatedPokemons = [...state.pokemons, ...result.pokemons];

      emit(
        state.copyWith(
          pokemons: updatedPokemons,
          filteredPokemons: PokemonSearchHelper.filterPokemons(
            updatedPokemons,
            state.searchQuery,
          ),
          offset: state.offset + ApiConstants.defaultPageSize,
          hasReachedMax: !result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  /// Search Pokemon with debounce
  void search(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final filtered = PokemonSearchHelper.filterPokemons(
        state.pokemons,
        query,
      );
      emit(state.copyWith(searchQuery: query, filteredPokemons: filtered));
    });
  }

  /// Clear search
  void clearSearch() {
    _debounceTimer?.cancel();
    emit(state.copyWith(searchQuery: '', filteredPokemons: state.pokemons));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
