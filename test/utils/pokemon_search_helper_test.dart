import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';
import 'package:pokemon/domain/index.dart';

void main() {
  group('PokemonSearchHelper', () {
    late List<Pokemon> testPokemons;

    setUp(() {
      testPokemons = [
        Pokemon(
          id: 1,
          name: 'bulbasaur',
          height: 7,
          weight: 69,
          imageUrl: 'https://example.com/1.png',
          types: [
            const PokemonType(slot: 1, name: 'grass'),
            const PokemonType(slot: 2, name: 'poison'),
          ],
          stats: [],
          abilities: [],
          moves: [],
          baseExperience: 64,
          order: 1,
        ),
        Pokemon(
          id: 4,
          name: 'charmander',
          height: 6,
          weight: 85,
          imageUrl: 'https://example.com/4.png',
          types: [const PokemonType(slot: 1, name: 'fire')],
          stats: [],
          abilities: [],
          moves: [],
          baseExperience: 62,
          order: 4,
        ),
        Pokemon(
          id: 25,
          name: 'pikachu',
          height: 4,
          weight: 60,
          imageUrl: 'https://example.com/25.png',
          types: [const PokemonType(slot: 1, name: 'electric')],
          stats: [],
          abilities: [],
          moves: [],
          baseExperience: 112,
          order: 25,
        ),
        Pokemon(
          id: 6,
          name: 'charizard',
          height: 17,
          weight: 905,
          imageUrl: 'https://example.com/6.png',
          types: [
            const PokemonType(slot: 1, name: 'fire'),
            const PokemonType(slot: 2, name: 'flying'),
          ],
          stats: [],
          abilities: [],
          moves: [],
          baseExperience: 240,
          order: 6,
        ),
      ];
    });

    group('filterPokemons', () {
      test('returns all pokemons when query is empty', () {
        final result = PokemonSearchHelper.filterPokemons(testPokemons, '');
        expect(result.length, equals(4));
      });

      test('returns all pokemons when query is whitespace only', () {
        final result = PokemonSearchHelper.filterPokemons(testPokemons, '   ');
        expect(result.length, equals(4));
      });

      test('filters by name (case-insensitive)', () {
        final result = PokemonSearchHelper.filterPokemons(
          testPokemons,
          'pikachu',
        );
        expect(result.length, equals(1));
        expect(result.first.name, equals('pikachu'));
      });

      test('filters by partial name', () {
        final result = PokemonSearchHelper.filterPokemons(testPokemons, 'char');
        expect(result.length, equals(2)); // charmander and charizard
      });

      test('filters by ID', () {
        final result = PokemonSearchHelper.filterPokemons(testPokemons, '25');
        expect(result.length, equals(1));
        expect(result.first.id, equals(25));
      });

      test('filters by type (case-insensitive)', () {
        final result = PokemonSearchHelper.filterPokemons(testPokemons, 'fire');
        expect(result.length, equals(2)); // charmander and charizard
      });

      test('filters by type with uppercase query', () {
        final result = PokemonSearchHelper.filterPokemons(testPokemons, 'FIRE');
        expect(result.length, equals(2));
      });

      test('returns empty list when no match found', () {
        final result = PokemonSearchHelper.filterPokemons(
          testPokemons,
          'mewtwo',
        );
        expect(result.isEmpty, isTrue);
      });

      test('matches by secondary type', () {
        final result = PokemonSearchHelper.filterPokemons(
          testPokemons,
          'flying',
        );
        expect(result.length, equals(1));
        expect(result.first.name, equals('charizard'));
      });
    });

    group('matchesByName', () {
      test('returns true for matching name', () {
        final pokemon = testPokemons.first;
        expect(PokemonSearchHelper.matchesByName(pokemon, 'bulba'), isTrue);
      });

      test('returns false for non-matching name', () {
        final pokemon = testPokemons.first;
        expect(PokemonSearchHelper.matchesByName(pokemon, 'pikachu'), isFalse);
      });

      test('is case-insensitive', () {
        final pokemon = testPokemons.first;
        expect(PokemonSearchHelper.matchesByName(pokemon, 'BULBA'), isTrue);
      });
    });

    group('matchesById', () {
      test('returns true for matching ID', () {
        final pokemon = testPokemons[2]; // pikachu, id: 25
        expect(PokemonSearchHelper.matchesById(pokemon, '25'), isTrue);
      });

      test('returns true for partial ID match', () {
        final pokemon = testPokemons[2];
        expect(PokemonSearchHelper.matchesById(pokemon, '2'), isTrue);
      });

      test('returns false for non-matching ID', () {
        final pokemon = testPokemons[2];
        expect(PokemonSearchHelper.matchesById(pokemon, '99'), isFalse);
      });
    });

    group('matchesByType', () {
      test('returns true for matching primary type', () {
        final pokemon = testPokemons[1]; // charmander, fire type
        expect(PokemonSearchHelper.matchesByType(pokemon, 'fire'), isTrue);
      });

      test('returns true for matching secondary type', () {
        final pokemon = testPokemons[3]; // charizard, fire/flying
        expect(PokemonSearchHelper.matchesByType(pokemon, 'flying'), isTrue);
      });

      test('returns false for non-matching type', () {
        final pokemon = testPokemons[2]; // pikachu, electric
        expect(PokemonSearchHelper.matchesByType(pokemon, 'water'), isFalse);
      });

      test('is case-insensitive', () {
        final pokemon = testPokemons[1];
        expect(PokemonSearchHelper.matchesByType(pokemon, 'FIRE'), isTrue);
      });
    });
  });
}
