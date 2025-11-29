import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/index.dart';
import '../../../domain/index.dart';

part 'pokemon_detail_state.dart';

/// Cubit for managing Pokemon detail page state
class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final PokemonRepository _pokemonRepository;

  PokemonDetailCubit(this._pokemonRepository)
    : super(
        PokemonDetailState(
          pokemonLoadData: ViewData.initial(),
          speciesLoadData: ViewData.initial(),
          evolutionLoadData: ViewData.initial(),
        ),
      );

  /// Load Pokemon detail by ID
  Future<void> loadPokemonDetail(int id, {Pokemon? initialPokemon}) async {
    // If we have initial pokemon data, use it
    if (initialPokemon != null) {
      emit(
        state.copyWith(
          pokemonLoadData: ViewData.loaded(data: initialPokemon),
          pokemon: initialPokemon,
        ),
      );
    } else {
      emit(state.copyWith(pokemonLoadData: ViewData.loading()));
    }

    try {
      // If we don't have initial pokemon, fetch it
      if (initialPokemon == null) {
        final pokemon = await _pokemonRepository.getPokemonDetail(id);
        emit(
          state.copyWith(
            pokemonLoadData: ViewData.loaded(data: pokemon),
            pokemon: pokemon,
          ),
        );
      }

      // Load species and evolution data
      await _loadSpeciesAndEvolution(id);
    } catch (e) {
      emit(
        state.copyWith(pokemonLoadData: ViewData.error(message: e.toString())),
      );
    }
  }

  Future<void> _loadSpeciesAndEvolution(int id) async {
    emit(state.copyWith(speciesLoadData: ViewData.loading()));

    try {
      final species = await _pokemonRepository.getPokemonSpecies(id);
      emit(
        state.copyWith(
          speciesLoadData: ViewData.loaded(data: species),
          species: species,
        ),
      );

      // Load evolution chain if available
      if (species.evolutionChainId != null) {
        emit(state.copyWith(evolutionLoadData: ViewData.loading()));
        final evolution = await _pokemonRepository.getEvolutionChain(
          species.evolutionChainId!,
        );
        emit(
          state.copyWith(
            evolutionLoadData: ViewData.loaded(data: evolution),
            evolution: evolution,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(speciesLoadData: ViewData.error(message: e.toString())),
      );
    }
  }

  /// Refresh all data
  Future<void> refresh(int id) async {
    emit(
      state.copyWith(
        pokemonLoadData: ViewData.loading(),
        speciesLoadData: ViewData.initial(),
        evolutionLoadData: ViewData.initial(),
        pokemon: null,
        species: null,
        evolution: null,
      ),
    );
    await loadPokemonDetail(id);
  }
}
