import '../../common/index.dart';
import '../../domain/index.dart';

/// Model for evolution chain data from API
class EvolutionChainModel extends EvolutionChain {
  const EvolutionChainModel({required super.id, required super.chain});

  factory EvolutionChainModel.fromJson(Map<String, dynamic> json) {
    final chainData = json['chain'] as Map<String, dynamic>? ?? {};

    return EvolutionChainModel(
      id: ReturnValue.integer(json['id']) ?? 0,
      chain: _parseEvolutionChain(chainData),
    );
  }

  static List<EvolutionStage> _parseEvolutionChain(
    Map<String, dynamic> chainData,
  ) {
    final List<EvolutionStage> stages = [];

    // Parse current stage
    final species = chainData['species'] as Map<String, dynamic>? ?? {};
    final speciesUrl = ReturnValue.string(species['url']) ?? '';
    final pokemonId = speciesUrl.extractIdFromUrl ?? 0;
    final pokemonName = ReturnValue.string(species['name']) ?? '';

    // Parse evolution details
    final evolutionDetails =
        chainData['evolution_details'] as List<dynamic>? ?? [];
    int? minLevel;
    String? trigger;
    String? item;

    if (evolutionDetails.isNotEmpty) {
      final details = evolutionDetails.first as Map<String, dynamic>;
      minLevel = ReturnValue.integer(details['min_level'], nullable: true);

      final triggerData = details['trigger'] as Map<String, dynamic>?;
      trigger = ReturnValue.string(triggerData?['name'], nullable: true);

      final itemData = details['item'] as Map<String, dynamic>?;
      item = ReturnValue.string(itemData?['name'], nullable: true);
    }

    // Parse evolutions
    final evolvesToData = chainData['evolves_to'] as List<dynamic>? ?? [];
    final evolvesTo = <EvolutionStage>[];

    for (final evolution in evolvesToData) {
      final evolutionMap = evolution as Map<String, dynamic>;
      evolvesTo.addAll(_parseEvolutionChain(evolutionMap));
    }

    stages.add(
      EvolutionStage(
        pokemonId: pokemonId,
        pokemonName: pokemonName,
        imageUrl: ApiConstants.getOfficialArtworkUrl(pokemonId),
        minLevel: minLevel,
        trigger: trigger,
        item: item,
        evolvesTo: evolvesTo,
      ),
    );

    return stages;
  }
}
