import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('StringExtensions', () {
    group('capitalize', () {
      test('capitalizes first letter of lowercase string', () {
        expect('hello'.capitalize, equals('Hello'));
      });

      test('keeps already capitalized string unchanged', () {
        expect('Hello'.capitalize, equals('Hello'));
      });

      test('handles single character string', () {
        expect('h'.capitalize, equals('H'));
      });

      test('handles empty string', () {
        expect(''.capitalize, equals(''));
      });

      test('handles string with numbers at start', () {
        expect('123abc'.capitalize, equals('123abc'));
      });

      test('handles all uppercase string', () {
        expect('HELLO'.capitalize, equals('HELLO'));
      });

      test('only capitalizes first character, keeps rest unchanged', () {
        expect('hELLO'.capitalize, equals('HELLO'));
      });
    });

    group('titleCase', () {
      test('converts lowercase string to title case', () {
        expect('hello world'.titleCase, equals('Hello World'));
      });

      test('handles single word', () {
        expect('hello'.titleCase, equals('Hello'));
      });

      test('handles multiple words', () {
        expect('the quick brown fox'.titleCase, equals('The Quick Brown Fox'));
      });

      test('handles empty string', () {
        expect(''.titleCase, equals(''));
      });

      test('handles already title case', () {
        expect('Hello World'.titleCase, equals('Hello World'));
      });
    });

    group('toReadable', () {
      test('converts hyphenated string to readable format', () {
        expect('special-attack'.toReadable, equals('Special Attack'));
      });

      test('handles multiple hyphens', () {
        expect('a-b-c'.toReadable, equals('A B C'));
      });

      test('handles string without hyphens', () {
        expect('attack'.toReadable, equals('Attack'));
      });
    });

    group('extractIdFromUrl', () {
      test('extracts ID from pokemon URL', () {
        expect(
          'https://pokeapi.co/api/v2/pokemon/25/'.extractIdFromUrl,
          equals(25),
        );
      });

      test('extracts ID from URL without trailing slash', () {
        expect(
          'https://pokeapi.co/api/v2/pokemon/150'.extractIdFromUrl,
          equals(150),
        );
      });

      test('returns null for empty string', () {
        expect(''.extractIdFromUrl, isNull);
      });

      test('returns null for URL without numeric ID', () {
        expect(
          'https://pokeapi.co/api/v2/pokemon/abc/'.extractIdFromUrl,
          isNull,
        );
      });
    });

    group('toShortStatName', () {
      test('converts hp to HP', () {
        expect('hp'.toShortStatName, equals('HP'));
      });

      test('converts attack to ATK', () {
        expect('attack'.toShortStatName, equals('ATK'));
      });

      test('converts defense to DEF', () {
        expect('defense'.toShortStatName, equals('DEF'));
      });

      test('converts special-attack to SATK', () {
        expect('special-attack'.toShortStatName, equals('SATK'));
      });

      test('converts special-defense to SDEF', () {
        expect('special-defense'.toShortStatName, equals('SDEF'));
      });

      test('converts speed to SPD', () {
        expect('speed'.toShortStatName, equals('SPD'));
      });

      test('returns uppercase for unknown stat', () {
        expect('unknown'.toShortStatName, equals('UNKNOWN'));
      });

      test('is case insensitive', () {
        expect('HP'.toShortStatName, equals('HP'));
        expect('Attack'.toShortStatName, equals('ATK'));
      });
    });
  });
}
