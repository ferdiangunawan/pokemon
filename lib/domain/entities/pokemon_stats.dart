import 'package:equatable/equatable.dart';

/// Pokemon stats entity (HP, Attack, Defense, etc.)
class PokemonStats extends Equatable {
  final String name;
  final int baseStat;
  final int effort;

  const PokemonStats({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  PokemonStats copyWith({String? name, int? baseStat, int? effort}) {
    return PokemonStats(
      name: name ?? this.name,
      baseStat: baseStat ?? this.baseStat,
      effort: effort ?? this.effort,
    );
  }

  @override
  List<Object?> get props => [name, baseStat, effort];
}
