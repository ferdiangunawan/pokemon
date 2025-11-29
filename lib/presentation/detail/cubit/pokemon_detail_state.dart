part of 'pokemon_detail_cubit.dart';

/// State for Pokemon detail page
class PokemonDetailState extends Equatable {
  final ViewData<Pokemon> pokemonLoadData;
  final ViewData<PokemonSpecies> speciesLoadData;
  final ViewData<EvolutionChain> evolutionLoadData;
  final Pokemon? pokemon;
  final PokemonSpecies? species;
  final EvolutionChain? evolution;

  const PokemonDetailState({
    required this.pokemonLoadData,
    required this.speciesLoadData,
    required this.evolutionLoadData,
    this.pokemon,
    this.species,
    this.evolution,
  });

  PokemonDetailState copyWith({
    ViewData<Pokemon>? pokemonLoadData,
    ViewData<PokemonSpecies>? speciesLoadData,
    ViewData<EvolutionChain>? evolutionLoadData,
    Pokemon? pokemon,
    PokemonSpecies? species,
    EvolutionChain? evolution,
  }) {
    return PokemonDetailState(
      pokemonLoadData: pokemonLoadData ?? this.pokemonLoadData,
      speciesLoadData: speciesLoadData ?? this.speciesLoadData,
      evolutionLoadData: evolutionLoadData ?? this.evolutionLoadData,
      pokemon: pokemon ?? this.pokemon,
      species: species ?? this.species,
      evolution: evolution ?? this.evolution,
    );
  }

  @override
  List<Object?> get props => [
    pokemonLoadData,
    speciesLoadData,
    evolutionLoadData,
    pokemon,
    species,
    evolution,
  ];
}
