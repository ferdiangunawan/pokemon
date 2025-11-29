import '../../common/index.dart';
import '../../domain/index.dart';

/// Model for Pokemon data from API
class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.height,
    required super.weight,
    required super.imageUrl,
    required super.types,
    required super.stats,
    required super.abilities,
    required super.moves,
    required super.baseExperience,
    required super.order,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final id = ReturnValue.integer(json['id']) ?? 0;

    // Parse types
    final typesData = json['types'] as List<dynamic>? ?? [];
    final types = typesData.map((typeData) {
      final typeInfo = typeData['type'] as Map<String, dynamic>? ?? {};
      return PokemonType(
        name: ReturnValue.string(typeInfo['name']) ?? '',
        slot: ReturnValue.integer(typeData['slot']) ?? 0,
      );
    }).toList();

    // Parse stats
    final statsData = json['stats'] as List<dynamic>? ?? [];
    final stats = statsData.map((statData) {
      final statInfo = statData['stat'] as Map<String, dynamic>? ?? {};
      return PokemonStats(
        name: ReturnValue.string(statInfo['name']) ?? '',
        baseStat: ReturnValue.integer(statData['base_stat']) ?? 0,
        effort: ReturnValue.integer(statData['effort']) ?? 0,
      );
    }).toList();

    // Parse abilities
    final abilitiesData = json['abilities'] as List<dynamic>? ?? [];
    final abilities = abilitiesData.map((abilityData) {
      final abilityInfo = abilityData['ability'] as Map<String, dynamic>? ?? {};
      return PokemonAbility(
        name: ReturnValue.string(abilityInfo['name']) ?? '',
        isHidden: ReturnValue.boolean(abilityData['is_hidden']) ?? false,
        slot: ReturnValue.integer(abilityData['slot']) ?? 0,
      );
    }).toList();

    // Parse moves (limit to first 20 for performance)
    final movesData = json['moves'] as List<dynamic>? ?? [];
    final moves = movesData.take(50).map((moveData) {
      final moveInfo = moveData['move'] as Map<String, dynamic>? ?? {};
      final versionGroupDetails =
          moveData['version_group_details'] as List<dynamic>? ?? [];
      final latestVersion = versionGroupDetails.isNotEmpty
          ? versionGroupDetails.last as Map<String, dynamic>
          : <String, dynamic>{};
      final moveLearnMethod =
          latestVersion['move_learn_method'] as Map<String, dynamic>? ?? {};

      return PokemonMove(
        name: ReturnValue.string(moveInfo['name']) ?? '',
        levelLearnedAt: ReturnValue.integer(
          latestVersion['level_learned_at'],
          nullable: true,
        ),
        learnMethod: ReturnValue.string(moveLearnMethod['name']) ?? '',
      );
    }).toList();

    // Get image URL
    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final other = sprites['other'] as Map<String, dynamic>? ?? {};
    final officialArtwork =
        other['official-artwork'] as Map<String, dynamic>? ?? {};
    String imageUrl =
        ReturnValue.string(officialArtwork['front_default']) ?? '';

    // Fallback to regular sprite if official artwork not available
    if (imageUrl.isEmpty) {
      imageUrl = ReturnValue.string(sprites['front_default']) ?? '';
    }

    // Final fallback to constructed URL
    if (imageUrl.isEmpty) {
      imageUrl = ApiConstants.getOfficialArtworkUrl(id);
    }

    return PokemonModel(
      id: id,
      name: ReturnValue.string(json['name']) ?? '',
      height: ReturnValue.integer(json['height']) ?? 0,
      weight: ReturnValue.integer(json['weight']) ?? 0,
      imageUrl: imageUrl,
      types: types,
      stats: stats,
      abilities: abilities,
      moves: moves,
      baseExperience: ReturnValue.integer(json['base_experience']) ?? 0,
      order: ReturnValue.integer(json['order']) ?? 0,
    );
  }
}
