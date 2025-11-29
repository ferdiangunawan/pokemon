import '../../common/index.dart';
import '../../core/index.dart';
import '../../domain/index.dart';
import '../models/index.dart';

/// Remote data source for Pokemon API
class PokemonRemoteDataSource {
  final NetworkClient _networkClient;

  PokemonRemoteDataSource(this._networkClient);

  /// Fetch paginated list of Pokemon
  Future<PokemonListResult> getPokemons({
    required int offset,
    required int limit,
  }) async {
    final response = await _networkClient.get(
      ApiConstants.pokemon,
      queryParameters: {'offset': offset, 'limit': limit},
    );

    final data = response.data as Map<String, dynamic>;
    final count = ReturnValue.integer(data['count']) ?? 0;
    final results = data['results'] as List<dynamic>? ?? [];

    // Fetch details for each Pokemon in parallel
    final pokemonFutures = results.map((item) async {
      final url = ReturnValue.string(item['url']) ?? '';
      final id = url.extractIdFromUrl;
      if (id != null) {
        return await getPokemonDetail(id);
      }
      return null;
    }).toList();

    final pokemons = (await Future.wait(
      pokemonFutures,
    )).whereType<Pokemon>().toList();

    final hasMore = offset + limit < count;

    return PokemonListResult(
      pokemons: pokemons,
      count: count,
      hasMore: hasMore,
    );
  }

  /// Fetch Pokemon detail by ID
  Future<Pokemon> getPokemonDetail(int id) async {
    final response = await _networkClient.get('${ApiConstants.pokemon}/$id');
    final data = response.data as Map<String, dynamic>;
    return PokemonModel.fromJson(data);
  }

  /// Fetch Pokemon species by ID
  Future<PokemonSpecies> getPokemonSpecies(int id) async {
    final response = await _networkClient.get(
      '${ApiConstants.pokemonSpecies}/$id',
    );
    final data = response.data as Map<String, dynamic>;
    return PokemonSpeciesModel.fromJson(data);
  }

  /// Fetch evolution chain by ID
  Future<EvolutionChain> getEvolutionChain(int id) async {
    final response = await _networkClient.get(
      '${ApiConstants.evolutionChain}/$id',
    );
    final data = response.data as Map<String, dynamic>;
    return EvolutionChainModel.fromJson(data);
  }
}
