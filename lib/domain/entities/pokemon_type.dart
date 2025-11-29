import 'package:equatable/equatable.dart';

/// Pokemon type entity (e.g., fire, water, grass)
class PokemonType extends Equatable {
  final String name;
  final int slot;

  const PokemonType({required this.name, required this.slot});

  PokemonType copyWith({String? name, int? slot}) {
    return PokemonType(name: name ?? this.name, slot: slot ?? this.slot);
  }

  @override
  List<Object?> get props => [name, slot];
}
