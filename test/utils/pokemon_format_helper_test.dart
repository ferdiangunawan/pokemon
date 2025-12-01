import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('PokemonFormatHelper', () {
    group('formatPokemonId', () {
      test('formats single digit ID with leading zeros', () {
        expect(PokemonFormatHelper.formatPokemonId(1), equals('001'));
      });

      test('formats double digit ID with leading zero', () {
        expect(PokemonFormatHelper.formatPokemonId(25), equals('025'));
      });

      test('formats triple digit ID without leading zeros', () {
        expect(PokemonFormatHelper.formatPokemonId(150), equals('150'));
      });

      test('formats ID larger than 3 digits', () {
        expect(PokemonFormatHelper.formatPokemonId(1000), equals('1000'));
      });

      test('formats with custom digit count', () {
        expect(
          PokemonFormatHelper.formatPokemonId(1, digits: 4),
          equals('0001'),
        );
      });

      test('handles zero ID', () {
        expect(PokemonFormatHelper.formatPokemonId(0), equals('000'));
      });
    });

    group('formatHeight', () {
      test('formats height from decimeters to meters', () {
        expect(PokemonFormatHelper.formatHeight(4), equals('0.4 m'));
      });

      test('formats height with decimal', () {
        expect(PokemonFormatHelper.formatHeight(17), equals('1.7 m'));
      });

      test('formats large height', () {
        expect(PokemonFormatHelper.formatHeight(200), equals('20.0 m'));
      });

      test('formats zero height', () {
        expect(PokemonFormatHelper.formatHeight(0), equals('0.0 m'));
      });

      test('formats height of 1 decimeter', () {
        expect(PokemonFormatHelper.formatHeight(1), equals('0.1 m'));
      });
    });

    group('formatWeight', () {
      test('formats weight from hectograms to kilograms', () {
        expect(PokemonFormatHelper.formatWeight(60), equals('6.0 kg'));
      });

      test('formats weight with decimal', () {
        expect(PokemonFormatHelper.formatWeight(905), equals('90.5 kg'));
      });

      test('formats large weight', () {
        expect(PokemonFormatHelper.formatWeight(10000), equals('1000.0 kg'));
      });

      test('formats zero weight', () {
        expect(PokemonFormatHelper.formatWeight(0), equals('0.0 kg'));
      });

      test('formats small weight', () {
        expect(PokemonFormatHelper.formatWeight(1), equals('0.1 kg'));
      });
    });

    group('heightToMeters', () {
      test('converts decimeters to meters', () {
        expect(PokemonFormatHelper.heightToMeters(10), equals(1.0));
      });

      test('converts with decimal result', () {
        expect(PokemonFormatHelper.heightToMeters(4), equals(0.4));
      });

      test('converts zero', () {
        expect(PokemonFormatHelper.heightToMeters(0), equals(0.0));
      });
    });

    group('weightToKg', () {
      test('converts hectograms to kilograms', () {
        expect(PokemonFormatHelper.weightToKg(100), equals(10.0));
      });

      test('converts with decimal result', () {
        expect(PokemonFormatHelper.weightToKg(60), equals(6.0));
      });

      test('converts zero', () {
        expect(PokemonFormatHelper.weightToKg(0), equals(0.0));
      });
    });

    group('formatPercentage', () {
      test('formats percentage with default decimals', () {
        expect(PokemonFormatHelper.formatPercentage(50.5), equals('50.5%'));
      });

      test('formats percentage with custom decimals', () {
        // Using 50.556 to ensure proper rounding to 50.56
        expect(
          PokemonFormatHelper.formatPercentage(50.556, decimals: 2),
          equals('50.56%'),
        );
      });

      test('formats percentage with zero decimals', () {
        expect(
          PokemonFormatHelper.formatPercentage(50.5, decimals: 0),
          equals('51%'),
        );
      });

      test('formats zero percentage', () {
        expect(PokemonFormatHelper.formatPercentage(0), equals('0.0%'));
      });

      test('formats 100 percentage', () {
        expect(PokemonFormatHelper.formatPercentage(100), equals('100.0%'));
      });
    });

    group('calculateMaleRatio', () {
      test('returns 100% male for gender rate 0', () {
        expect(PokemonFormatHelper.calculateMaleRatio(0), equals(100.0));
      });

      test('returns 0% male for gender rate 8', () {
        expect(PokemonFormatHelper.calculateMaleRatio(8), equals(0.0));
      });

      test('returns 50% male for gender rate 4', () {
        expect(PokemonFormatHelper.calculateMaleRatio(4), equals(50.0));
      });

      test('returns 87.5% male for gender rate 1', () {
        expect(PokemonFormatHelper.calculateMaleRatio(1), equals(87.5));
      });

      test('returns 0% for genderless (rate -1)', () {
        expect(PokemonFormatHelper.calculateMaleRatio(-1), equals(0.0));
      });
    });

    group('calculateFemaleRatio', () {
      test('returns 0% female for gender rate 0', () {
        expect(PokemonFormatHelper.calculateFemaleRatio(0), equals(0.0));
      });

      test('returns 100% female for gender rate 8', () {
        expect(PokemonFormatHelper.calculateFemaleRatio(8), equals(100.0));
      });

      test('returns 50% female for gender rate 4', () {
        expect(PokemonFormatHelper.calculateFemaleRatio(4), equals(50.0));
      });

      test('returns 12.5% female for gender rate 1', () {
        expect(PokemonFormatHelper.calculateFemaleRatio(1), equals(12.5));
      });

      test('returns 0% for genderless (rate -1)', () {
        expect(PokemonFormatHelper.calculateFemaleRatio(-1), equals(0.0));
      });
    });

    group('isGenderless', () {
      test('returns true for gender rate -1', () {
        expect(PokemonFormatHelper.isGenderless(-1), isTrue);
      });

      test('returns false for gender rate 0', () {
        expect(PokemonFormatHelper.isGenderless(0), isFalse);
      });

      test('returns false for gender rate 4', () {
        expect(PokemonFormatHelper.isGenderless(4), isFalse);
      });

      test('returns false for gender rate 8', () {
        expect(PokemonFormatHelper.isGenderless(8), isFalse);
      });
    });
  });
}
