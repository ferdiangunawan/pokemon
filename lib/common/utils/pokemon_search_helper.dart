import '../../../domain/index.dart';

/// Helper class for Pokemon search and filtering operations
class PokemonSearchHelper {
  const PokemonSearchHelper._();

  /// Filter Pokemon list by search query
  ///
  /// Matches against:
  /// - Pokemon name (case-insensitive)
  /// - Pokemon ID
  /// - Pokemon types (case-insensitive)
  static List<Pokemon> filterPokemons(List<Pokemon> pokemons, String query) {
    if (query.isEmpty) return pokemons;

    final lowerQuery = query.toLowerCase().trim();
    return pokemons.where((pokemon) {
      // Match by name
      if (pokemon.name.toLowerCase().contains(lowerQuery)) return true;
      // Match by ID
      if (pokemon.id.toString().contains(query)) return true;
      // Match by type
      if (pokemon.types.any(
        (type) => type.name.toLowerCase().contains(lowerQuery),
      )) {
        return true;
      }
      return false;
    }).toList();
  }

  /// Check if search query matches Pokemon by name
  static bool matchesByName(Pokemon pokemon, String query) {
    return pokemon.name.toLowerCase().contains(query.toLowerCase());
  }

  /// Check if search query matches Pokemon by ID
  static bool matchesById(Pokemon pokemon, String query) {
    return pokemon.id.toString().contains(query);
  }

  /// Check if search query matches Pokemon by type
  static bool matchesByType(Pokemon pokemon, String query) {
    return pokemon.types.any(
      (type) => type.name.toLowerCase().contains(query.toLowerCase()),
    );
  }
}
