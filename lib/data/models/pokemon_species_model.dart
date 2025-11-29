import '../../common/index.dart';
import '../../domain/index.dart';

/// Model for Pokemon species data from API
class PokemonSpeciesModel extends PokemonSpecies {
  const PokemonSpeciesModel({
    required super.id,
    required super.name,
    super.description,
    super.genus,
    super.captureRate,
    super.baseHappiness,
    required super.isBaby,
    required super.isLegendary,
    required super.isMythical,
    super.genderRate,
    super.hatchCounter,
    required super.eggGroups,
    super.evolutionChainId,
  });

  factory PokemonSpeciesModel.fromJson(Map<String, dynamic> json) {
    // Get English flavor text (description)
    final flavorTextEntries =
        json['flavor_text_entries'] as List<dynamic>? ?? [];
    String? description;
    for (final entry in flavorTextEntries) {
      final language = entry['language'] as Map<String, dynamic>? ?? {};
      if (ReturnValue.string(language['name']) == 'en') {
        description = ReturnValue.string(
          entry['flavor_text'],
        )?.replaceAll('\n', ' ').replaceAll('\f', ' ').replaceAll('  ', ' ');
        break;
      }
    }

    // Get English genus
    final genera = json['genera'] as List<dynamic>? ?? [];
    String? genus;
    for (final entry in genera) {
      final language = entry['language'] as Map<String, dynamic>? ?? {};
      if (ReturnValue.string(language['name']) == 'en') {
        genus = ReturnValue.string(entry['genus']);
        break;
      }
    }

    // Get egg groups
    final eggGroupsData = json['egg_groups'] as List<dynamic>? ?? [];
    final eggGroups = eggGroupsData
        .map((group) {
          return ReturnValue.string(group['name']) ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList();

    // Get evolution chain ID
    final evolutionChain = json['evolution_chain'] as Map<String, dynamic>?;
    final evolutionChainUrl = ReturnValue.string(evolutionChain?['url']);
    final evolutionChainId = evolutionChainUrl?.extractIdFromUrl;

    return PokemonSpeciesModel(
      id: ReturnValue.integer(json['id']) ?? 0,
      name: ReturnValue.string(json['name']) ?? '',
      description: description,
      genus: genus,
      captureRate: ReturnValue.integer(json['capture_rate'], nullable: true),
      baseHappiness: ReturnValue.integer(
        json['base_happiness'],
        nullable: true,
      ),
      isBaby: ReturnValue.boolean(json['is_baby']) ?? false,
      isLegendary: ReturnValue.boolean(json['is_legendary']) ?? false,
      isMythical: ReturnValue.boolean(json['is_mythical']) ?? false,
      genderRate: ReturnValue.integer(json['gender_rate'], nullable: true),
      hatchCounter: ReturnValue.integer(json['hatch_counter'], nullable: true),
      eggGroups: eggGroups,
      evolutionChainId: evolutionChainId,
    );
  }
}
