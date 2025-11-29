/// API Constants for PokeAPI
class ApiConstants {
  const ApiConstants._();

  /// Base URL for PokeAPI
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  /// Endpoints
  static const String pokemon = '/pokemon';
  static const String pokemonSpecies = '/pokemon-species';
  static const String evolutionChain = '/evolution-chain';
  static const String type = '/type';
  static const String ability = '/ability';
  static const String move = '/move';

  /// Image URLs
  static const String officialArtworkBaseUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork';
  static const String dreamWorldBaseUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world';
  static const String homeBaseUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home';

  /// Get official artwork URL for a Pokemon
  static String getOfficialArtworkUrl(int id) =>
      '$officialArtworkBaseUrl/$id.png';

  /// Get dream world sprite URL for a Pokemon
  static String getDreamWorldUrl(int id) => '$dreamWorldBaseUrl/$id.svg';

  /// Get home sprite URL for a Pokemon
  static String getHomeUrl(int id) => '$homeBaseUrl/$id.png';

  /// Default page size for pagination
  static const int defaultPageSize = 20;

  /// Maximum stat value for Pokemon (used for stat bars)
  static const int maxStatValue = 255;

  /// Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
