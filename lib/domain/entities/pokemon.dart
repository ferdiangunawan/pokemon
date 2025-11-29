import 'package:equatable/equatable.dart';

import 'pokemon_type.dart';
import 'pokemon_stats.dart';
import 'pokemon_ability.dart';
import 'pokemon_move.dart';

/// Pokemon entity representing a Pokemon
class Pokemon extends Equatable {
  final int id;
  final String name;
  final int height; // in decimeters
  final int weight; // in hectograms
  final String imageUrl;
  final List<PokemonType> types;
  final List<PokemonStats> stats;
  final List<PokemonAbility> abilities;
  final List<PokemonMove> moves;
  final int baseExperience;
  final int order;

  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.abilities,
    required this.moves,
    required this.baseExperience,
    required this.order,
  });

  /// Get height in meters
  double get heightInMeters => height / 10.0;

  /// Get weight in kilograms
  double get weightInKg => weight / 10.0;

  /// Get formatted height string
  String get formattedHeight => '${heightInMeters.toStringAsFixed(1)} m';

  /// Get formatted weight string
  String get formattedWeight => '${weightInKg.toStringAsFixed(1)} kg';

  /// Get primary type (first type)
  String get primaryType => types.isNotEmpty ? types.first.name : 'normal';

  /// Get total stats
  int get totalStats => stats.fold(0, (sum, stat) => sum + stat.baseStat);

  /// Create a copy with updated fields
  Pokemon copyWith({
    int? id,
    String? name,
    int? height,
    int? weight,
    String? imageUrl,
    List<PokemonType>? types,
    List<PokemonStats>? stats,
    List<PokemonAbility>? abilities,
    List<PokemonMove>? moves,
    int? baseExperience,
    int? order,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
      stats: stats ?? this.stats,
      abilities: abilities ?? this.abilities,
      moves: moves ?? this.moves,
      baseExperience: baseExperience ?? this.baseExperience,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    height,
    weight,
    imageUrl,
    types,
    stats,
    abilities,
    moves,
    baseExperience,
    order,
  ];
}
