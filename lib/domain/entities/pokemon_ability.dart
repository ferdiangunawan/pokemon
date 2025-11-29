import 'package:equatable/equatable.dart';

/// Pokemon ability entity
class PokemonAbility extends Equatable {
  final String name;
  final bool isHidden;
  final int slot;

  const PokemonAbility({
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  PokemonAbility copyWith({String? name, bool? isHidden, int? slot}) {
    return PokemonAbility(
      name: name ?? this.name,
      isHidden: isHidden ?? this.isHidden,
      slot: slot ?? this.slot,
    );
  }

  @override
  List<Object?> get props => [name, isHidden, slot];
}
