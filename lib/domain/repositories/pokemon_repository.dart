import '../entities/index.dart';

/// Repository interface for Pokemon data operations
abstract class PokemonRepository {
  /// Get a paginated list of Pokemon
  /// [offset] - Starting position
  /// [limit] - Number of Pokemon to fetch
  Future<PokemonListResult> getPokemons({
    required int offset,
    required int limit,
  });

  /// Get detailed Pokemon information by ID
  Future<Pokemon> getPokemonDetail(int id);

  /// Get Pokemon species information (for description, evolution chain, etc.)
  Future<PokemonSpecies> getPokemonSpecies(int id);

  /// Get evolution chain by ID
  Future<EvolutionChain> getEvolutionChain(int id);
}

/// Result wrapper for paginated Pokemon list
class PokemonListResult {
  final List<Pokemon> pokemons;
  final int count;
  final bool hasMore;

  const PokemonListResult({
    required this.pokemons,
    required this.count,
    required this.hasMore,
  });
}
