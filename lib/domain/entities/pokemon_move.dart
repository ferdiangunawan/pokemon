import 'package:equatable/equatable.dart';

/// Pokemon move entity
class PokemonMove extends Equatable {
  final String name;
  final int? levelLearnedAt;
  final String learnMethod;

  const PokemonMove({
    required this.name,
    this.levelLearnedAt,
    required this.learnMethod,
  });

  PokemonMove copyWith({
    String? name,
    int? levelLearnedAt,
    String? learnMethod,
  }) {
    return PokemonMove(
      name: name ?? this.name,
      levelLearnedAt: levelLearnedAt ?? this.levelLearnedAt,
      learnMethod: learnMethod ?? this.learnMethod,
    );
  }

  @override
  List<Object?> get props => [name, levelLearnedAt, learnMethod];
}
