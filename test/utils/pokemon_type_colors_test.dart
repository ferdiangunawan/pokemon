import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('PokemonTypeColors', () {
    group('typeColors', () {
      test('contains all 18 Pokemon types', () {
        expect(PokemonTypeColors.typeColors.length, equals(18));
      });

      test('contains normal type', () {
        expect(PokemonTypeColors.typeColors.containsKey('normal'), isTrue);
      });

      test('contains fire type', () {
        expect(PokemonTypeColors.typeColors.containsKey('fire'), isTrue);
      });

      test('contains water type', () {
        expect(PokemonTypeColors.typeColors.containsKey('water'), isTrue);
      });

      test('contains electric type', () {
        expect(PokemonTypeColors.typeColors.containsKey('electric'), isTrue);
      });

      test('contains grass type', () {
        expect(PokemonTypeColors.typeColors.containsKey('grass'), isTrue);
      });

      test('contains ice type', () {
        expect(PokemonTypeColors.typeColors.containsKey('ice'), isTrue);
      });

      test('contains fighting type', () {
        expect(PokemonTypeColors.typeColors.containsKey('fighting'), isTrue);
      });

      test('contains poison type', () {
        expect(PokemonTypeColors.typeColors.containsKey('poison'), isTrue);
      });

      test('contains ground type', () {
        expect(PokemonTypeColors.typeColors.containsKey('ground'), isTrue);
      });

      test('contains flying type', () {
        expect(PokemonTypeColors.typeColors.containsKey('flying'), isTrue);
      });

      test('contains psychic type', () {
        expect(PokemonTypeColors.typeColors.containsKey('psychic'), isTrue);
      });

      test('contains bug type', () {
        expect(PokemonTypeColors.typeColors.containsKey('bug'), isTrue);
      });

      test('contains rock type', () {
        expect(PokemonTypeColors.typeColors.containsKey('rock'), isTrue);
      });

      test('contains ghost type', () {
        expect(PokemonTypeColors.typeColors.containsKey('ghost'), isTrue);
      });

      test('contains dragon type', () {
        expect(PokemonTypeColors.typeColors.containsKey('dragon'), isTrue);
      });

      test('contains dark type', () {
        expect(PokemonTypeColors.typeColors.containsKey('dark'), isTrue);
      });

      test('contains steel type', () {
        expect(PokemonTypeColors.typeColors.containsKey('steel'), isTrue);
      });

      test('contains fairy type', () {
        expect(PokemonTypeColors.typeColors.containsKey('fairy'), isTrue);
      });
    });

    group('getTypeColor', () {
      test('returns correct color for fire type', () {
        final color = PokemonTypeColors.getTypeColor('fire');
        expect(color, equals(const Color(0xFFF08030)));
      });

      test('returns correct color for water type', () {
        final color = PokemonTypeColors.getTypeColor('water');
        expect(color, equals(const Color(0xFF6890F0)));
      });

      test('returns correct color for electric type', () {
        final color = PokemonTypeColors.getTypeColor('electric');
        expect(color, equals(const Color(0xFFF8D030)));
      });

      test('is case-insensitive', () {
        final lowerCase = PokemonTypeColors.getTypeColor('fire');
        final upperCase = PokemonTypeColors.getTypeColor('FIRE');
        final mixedCase = PokemonTypeColors.getTypeColor('Fire');

        expect(lowerCase, equals(upperCase));
        expect(lowerCase, equals(mixedCase));
      });

      test('returns normal color for unknown type', () {
        final color = PokemonTypeColors.getTypeColor('unknown');
        expect(color, equals(PokemonTypeColors.typeColors['normal']));
      });
    });

    group('getTypeDarkColor', () {
      test('returns correct dark color for fire type', () {
        final color = PokemonTypeColors.getTypeDarkColor('fire');
        expect(color, equals(const Color(0xFF9C531F)));
      });

      test('returns correct dark color for water type', () {
        final color = PokemonTypeColors.getTypeDarkColor('water');
        expect(color, equals(const Color(0xFF445E9C)));
      });

      test('returns normal dark color for unknown type', () {
        final color = PokemonTypeColors.getTypeDarkColor('unknown');
        expect(color, equals(PokemonTypeColors.typeDarkColors['normal']));
      });
    });

    group('getTypeGradient', () {
      test('returns two colors for gradient', () {
        final gradient = PokemonTypeColors.getTypeGradient('fire');
        expect(gradient.length, equals(2));
      });

      test('first color is light, second is dark', () {
        final gradient = PokemonTypeColors.getTypeGradient('fire');
        expect(gradient.first, equals(PokemonTypeColors.getTypeColor('fire')));
        expect(
          gradient.last,
          equals(PokemonTypeColors.getTypeDarkColor('fire')),
        );
      });
    });

    group('getPokemonGradient', () {
      test('returns normal gradient for empty types', () {
        final gradient = PokemonTypeColors.getPokemonGradient([]);
        expect(gradient, equals(PokemonTypeColors.getTypeGradient('normal')));
      });

      test('returns single type gradient for one type', () {
        final gradient = PokemonTypeColors.getPokemonGradient(['fire']);
        expect(gradient, equals(PokemonTypeColors.getTypeGradient('fire')));
      });

      test('returns mixed gradient for two types', () {
        final gradient = PokemonTypeColors.getPokemonGradient([
          'fire',
          'flying',
        ]);
        expect(gradient.first, equals(PokemonTypeColors.getTypeColor('fire')));
        expect(gradient.last, equals(PokemonTypeColors.getTypeColor('flying')));
      });

      test('uses first and last type for multiple types', () {
        final gradient = PokemonTypeColors.getPokemonGradient([
          'fire',
          'fighting',
          'flying',
        ]);
        expect(gradient.first, equals(PokemonTypeColors.getTypeColor('fire')));
        expect(gradient.last, equals(PokemonTypeColors.getTypeColor('flying')));
      });
    });

    group('getContrastingTextColor', () {
      test('returns light color for dark backgrounds', () {
        // Electric type is bright/light
        final color = PokemonTypeColors.getContrastingTextColor('dark');
        expect(color, equals(Colors.white));
      });

      test('returns dark color for light backgrounds', () {
        // Electric type is bright/light - should return dark text
        final color = PokemonTypeColors.getContrastingTextColor('electric');
        // Electric is bright so should return black87
        expect(color, equals(Colors.black87));
      });
    });
  });
}
