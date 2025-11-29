import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/domain/index.dart';

void main() {
  group('Pokemon', () {
    Pokemon createPokemon({
      int id = 25,
      String name = 'pikachu',
      int height = 4,
      int weight = 60,
      List<PokemonType>? types,
      List<PokemonStats>? stats,
      List<PokemonAbility>? abilities,
    }) {
      return Pokemon(
        id: id,
        name: name,
        height: height,
        weight: weight,
        imageUrl: 'https://example.com/pokemon.png',
        types: types ?? [const PokemonType(slot: 1, name: 'electric')],
        stats: stats ?? [],
        abilities: abilities ?? [],
        moves: [],
        baseExperience: 112,
        order: id,
      );
    }

    test('should create Pokemon from values', () {
      final pokemon = createPokemon();

      expect(pokemon.id, equals(25));
      expect(pokemon.name, equals('pikachu'));
      expect(pokemon.primaryType, equals('electric'));
    });

    test('primaryType should return first type', () {
      final pokemon = createPokemon(
        id: 6,
        name: 'charizard',
        types: [
          const PokemonType(slot: 1, name: 'fire'),
          const PokemonType(slot: 2, name: 'flying'),
        ],
      );

      expect(pokemon.primaryType, equals('fire'));
    });

    test('primaryType should return normal for empty types', () {
      final pokemon = createPokemon(types: []);
      expect(pokemon.primaryType, equals('normal'));
    });

    test('totalStats should sum all base stats', () {
      final pokemon = createPokemon(
        stats: [
          const PokemonStats(name: 'hp', baseStat: 35, effort: 0),
          const PokemonStats(name: 'attack', baseStat: 55, effort: 0),
          const PokemonStats(name: 'defense', baseStat: 40, effort: 0),
          const PokemonStats(name: 'special-attack', baseStat: 50, effort: 0),
          const PokemonStats(name: 'special-defense', baseStat: 50, effort: 0),
          const PokemonStats(name: 'speed', baseStat: 90, effort: 0),
        ],
      );

      expect(pokemon.totalStats, equals(320));
    });

    test('formattedHeight should return height in meters', () {
      final pokemon = createPokemon(height: 4); // 0.4m
      expect(pokemon.formattedHeight, equals('0.4 m'));
    });

    test('formattedWeight should return weight in kg', () {
      final pokemon = createPokemon(weight: 60); // 6.0kg
      expect(pokemon.formattedWeight, equals('6.0 kg'));
    });
  });

  group('PokemonType', () {
    test('should create PokemonType', () {
      const type = PokemonType(slot: 1, name: 'fire');

      expect(type.slot, equals(1));
      expect(type.name, equals('fire'));
    });
  });

  group('PokemonStats', () {
    test('should create PokemonStats', () {
      const stats = PokemonStats(name: 'hp', baseStat: 100, effort: 1);

      expect(stats.name, equals('hp'));
      expect(stats.baseStat, equals(100));
      expect(stats.effort, equals(1));
    });
  });
}
