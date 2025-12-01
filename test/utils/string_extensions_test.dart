import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize should capitalize first letter', () {
      expect('pikachu'.capitalize, equals('Pikachu'));
      expect('CHARMANDER'.capitalize, equals('CHARMANDER'));
      expect('bulbasaur'.capitalize, equals('Bulbasaur'));
    });

    test('capitalize should handle empty string', () {
      expect(''.capitalize, equals(''));
    });

    test('capitalize should handle single character', () {
      expect('a'.capitalize, equals('A'));
      expect('A'.capitalize, equals('A'));
    });

    test('toReadable should convert kebab-case to readable', () {
      expect('special-attack'.toReadable, equals('Special Attack'));
      expect('hp'.toReadable, equals('Hp'));
      expect('thunder-shock'.toReadable, equals('Thunder Shock'));
    });

    test('toReadable should handle string without hyphens', () {
      expect('attack'.toReadable, equals('Attack'));
      expect('defense'.toReadable, equals('Defense'));
    });
  });
}
