import 'package:equatable/equatable.dart';

/// Evolution chain entity
class EvolutionChain extends Equatable {
  final int id;
  final List<EvolutionStage> chain;

  const EvolutionChain({required this.id, required this.chain});

  @override
  List<Object?> get props => [id, chain];
}

/// Single evolution stage in the chain
class EvolutionStage extends Equatable {
  final int pokemonId;
  final String pokemonName;
  final String? imageUrl;
  final int? minLevel;
  final String? trigger;
  final String? item;
  final List<EvolutionStage> evolvesTo;

  const EvolutionStage({
    required this.pokemonId,
    required this.pokemonName,
    this.imageUrl,
    this.minLevel,
    this.trigger,
    this.item,
    required this.evolvesTo,
  });

  @override
  List<Object?> get props => [
    pokemonId,
    pokemonName,
    imageUrl,
    minLevel,
    trigger,
    item,
    evolvesTo,
  ];
}
