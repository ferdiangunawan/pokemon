import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/common/index.dart';

void main() {
  group('PokemonStatsHelper', () {
    group('constants', () {
      test('maxStatValue is 255', () {
        expect(PokemonStatsHelper.maxStatValue, equals(255));
      });

      test('maxTotalStats is 1530 (6 * 255)', () {
        expect(PokemonStatsHelper.maxTotalStats, equals(1530));
      });
    });

    group('calculateStatPercentage', () {
      test('returns 0.0 for stat value 0', () {
        expect(PokemonStatsHelper.calculateStatPercentage(0), equals(0.0));
      });

      test('returns 1.0 for stat value 255', () {
        expect(PokemonStatsHelper.calculateStatPercentage(255), equals(1.0));
      });

      test('returns correct percentage for mid-range value', () {
        final result = PokemonStatsHelper.calculateStatPercentage(127);
        expect(result, closeTo(0.498, 0.01));
      });

      test('clamps values above max to 1.0', () {
        expect(PokemonStatsHelper.calculateStatPercentage(300), equals(1.0));
      });

      test('returns correct percentage for common stat values', () {
        // HP 100 out of 255
        expect(
          PokemonStatsHelper.calculateStatPercentage(100),
          closeTo(0.392, 0.01),
        );
      });
    });

    group('calculateTotalStatsPercentage', () {
      test('returns 0.0 for total 0', () {
        expect(
          PokemonStatsHelper.calculateTotalStatsPercentage(0),
          equals(0.0),
        );
      });

      test('returns 1.0 for max total 1530', () {
        expect(
          PokemonStatsHelper.calculateTotalStatsPercentage(1530),
          equals(1.0),
        );
      });

      test('returns correct percentage for typical Pokemon total', () {
        // Pikachu's total stats: 320
        final result = PokemonStatsHelper.calculateTotalStatsPercentage(320);
        expect(result, closeTo(0.209, 0.01));
      });
    });

    group('getStatRating', () {
      test('returns legendary for 600+', () {
        expect(
          PokemonStatsHelper.getStatRating(600),
          equals(StatRating.legendary),
        );
        expect(
          PokemonStatsHelper.getStatRating(720),
          equals(StatRating.legendary),
        );
      });

      test('returns excellent for 500-599', () {
        expect(
          PokemonStatsHelper.getStatRating(500),
          equals(StatRating.excellent),
        );
        expect(
          PokemonStatsHelper.getStatRating(599),
          equals(StatRating.excellent),
        );
      });

      test('returns good for 400-499', () {
        expect(PokemonStatsHelper.getStatRating(400), equals(StatRating.good));
        expect(PokemonStatsHelper.getStatRating(499), equals(StatRating.good));
      });

      test('returns average for 300-399', () {
        expect(
          PokemonStatsHelper.getStatRating(300),
          equals(StatRating.average),
        );
        expect(
          PokemonStatsHelper.getStatRating(399),
          equals(StatRating.average),
        );
      });

      test('returns belowAverage for < 300', () {
        expect(
          PokemonStatsHelper.getStatRating(299),
          equals(StatRating.belowAverage),
        );
        expect(
          PokemonStatsHelper.getStatRating(100),
          equals(StatRating.belowAverage),
        );
      });
    });

    group('getStatQuality', () {
      test('returns exceptional for 150+', () {
        expect(
          PokemonStatsHelper.getStatQuality(150),
          equals(StatQuality.exceptional),
        );
        expect(
          PokemonStatsHelper.getStatQuality(200),
          equals(StatQuality.exceptional),
        );
      });

      test('returns great for 120-149', () {
        expect(
          PokemonStatsHelper.getStatQuality(120),
          equals(StatQuality.great),
        );
        expect(
          PokemonStatsHelper.getStatQuality(149),
          equals(StatQuality.great),
        );
      });

      test('returns good for 90-119', () {
        expect(PokemonStatsHelper.getStatQuality(90), equals(StatQuality.good));
        expect(
          PokemonStatsHelper.getStatQuality(119),
          equals(StatQuality.good),
        );
      });

      test('returns average for 60-89', () {
        expect(
          PokemonStatsHelper.getStatQuality(60),
          equals(StatQuality.average),
        );
        expect(
          PokemonStatsHelper.getStatQuality(89),
          equals(StatQuality.average),
        );
      });

      test('returns low for < 60', () {
        expect(PokemonStatsHelper.getStatQuality(59), equals(StatQuality.low));
        expect(PokemonStatsHelper.getStatQuality(0), equals(StatQuality.low));
      });
    });

    group('getShortStatName', () {
      test('returns HP for hp', () {
        expect(PokemonStatsHelper.getShortStatName('hp'), equals('HP'));
        expect(PokemonStatsHelper.getShortStatName('HP'), equals('HP'));
      });

      test('returns ATK for attack', () {
        expect(PokemonStatsHelper.getShortStatName('attack'), equals('ATK'));
      });

      test('returns DEF for defense', () {
        expect(PokemonStatsHelper.getShortStatName('defense'), equals('DEF'));
      });

      test('returns SATK for special-attack', () {
        expect(
          PokemonStatsHelper.getShortStatName('special-attack'),
          equals('SATK'),
        );
      });

      test('returns SDEF for special-defense', () {
        expect(
          PokemonStatsHelper.getShortStatName('special-defense'),
          equals('SDEF'),
        );
      });

      test('returns SPD for speed', () {
        expect(PokemonStatsHelper.getShortStatName('speed'), equals('SPD'));
      });

      test('returns uppercase for unknown stat', () {
        expect(
          PokemonStatsHelper.getShortStatName('unknown'),
          equals('UNKNOWN'),
        );
      });
    });
  });
}
