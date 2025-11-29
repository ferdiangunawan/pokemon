import 'package:equatable/equatable.dart';

/// Pokemon species entity with additional details
class PokemonSpecies extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? genus;
  final int? captureRate;
  final int? baseHappiness;
  final bool isBaby;
  final bool isLegendary;
  final bool isMythical;
  final int? genderRate; // -1 for genderless, 0-8 for female ratio
  final int? hatchCounter;
  final List<String> eggGroups;
  final int? evolutionChainId;

  const PokemonSpecies({
    required this.id,
    required this.name,
    this.description,
    this.genus,
    this.captureRate,
    this.baseHappiness,
    required this.isBaby,
    required this.isLegendary,
    required this.isMythical,
    this.genderRate,
    this.hatchCounter,
    required this.eggGroups,
    this.evolutionChainId,
  });

  /// Get gender ratio as percentage
  double? get femaleRatio =>
      genderRate != null && genderRate! >= 0 ? genderRate! / 8 * 100 : null;

  double? get maleRatio => femaleRatio != null ? 100 - femaleRatio! : null;

  bool get isGenderless => genderRate == -1;

  PokemonSpecies copyWith({
    int? id,
    String? name,
    String? description,
    String? genus,
    int? captureRate,
    int? baseHappiness,
    bool? isBaby,
    bool? isLegendary,
    bool? isMythical,
    int? genderRate,
    int? hatchCounter,
    List<String>? eggGroups,
    int? evolutionChainId,
  }) {
    return PokemonSpecies(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      genus: genus ?? this.genus,
      captureRate: captureRate ?? this.captureRate,
      baseHappiness: baseHappiness ?? this.baseHappiness,
      isBaby: isBaby ?? this.isBaby,
      isLegendary: isLegendary ?? this.isLegendary,
      isMythical: isMythical ?? this.isMythical,
      genderRate: genderRate ?? this.genderRate,
      hatchCounter: hatchCounter ?? this.hatchCounter,
      eggGroups: eggGroups ?? this.eggGroups,
      evolutionChainId: evolutionChainId ?? this.evolutionChainId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    genus,
    captureRate,
    baseHappiness,
    isBaby,
    isLegendary,
    isMythical,
    genderRate,
    hatchCounter,
    eggGroups,
    evolutionChainId,
  ];
}
