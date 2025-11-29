import '../../domain/index.dart';
import '../datasources/index.dart';

/// Implementation of PokemonRepository
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource _remoteDataSource;

  PokemonRepositoryImpl(this._remoteDataSource);

  @override
  Future<PokemonListResult> getPokemons({
    required int offset,
    required int limit,
  }) async {
    return await _remoteDataSource.getPokemons(offset: offset, limit: limit);
  }

  @override
  Future<Pokemon> getPokemonDetail(int id) async {
    return await _remoteDataSource.getPokemonDetail(id);
  }

  @override
  Future<PokemonSpecies> getPokemonSpecies(int id) async {
    return await _remoteDataSource.getPokemonSpecies(id);
  }

  @override
  Future<EvolutionChain> getEvolutionChain(int id) async {
    return await _remoteDataSource.getEvolutionChain(id);
  }
}
