/// Helper class for Pokemon stat calculations
class PokemonStatsHelper {
  const PokemonStatsHelper._();

  /// Maximum base stat value (highest possible stat value in Pokemon games)
  static const int maxStatValue = 255;

  /// Maximum total stats (6 stats * 255)
  static const int maxTotalStats = 6 * maxStatValue;

  /// Calculate stat percentage relative to max stat value
  static double calculateStatPercentage(int statValue) {
    return (statValue / maxStatValue).clamp(0.0, 1.0);
  }

  /// Calculate total stats percentage
  static double calculateTotalStatsPercentage(int totalStats) {
    return (totalStats / maxTotalStats).clamp(0.0, 1.0);
  }

  /// Get stat rating based on total stats
  static StatRating getStatRating(int totalStats) {
    if (totalStats >= 600) return StatRating.legendary;
    if (totalStats >= 500) return StatRating.excellent;
    if (totalStats >= 400) return StatRating.good;
    if (totalStats >= 300) return StatRating.average;
    return StatRating.belowAverage;
  }

  /// Get individual stat quality
  static StatQuality getStatQuality(int statValue) {
    if (statValue >= 150) return StatQuality.exceptional;
    if (statValue >= 120) return StatQuality.great;
    if (statValue >= 90) return StatQuality.good;
    if (statValue >= 60) return StatQuality.average;
    return StatQuality.low;
  }

  /// Get short stat name
  static String getShortStatName(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'special-attack':
        return 'SATK';
      case 'special-defense':
        return 'SDEF';
      case 'speed':
        return 'SPD';
      default:
        return statName.toUpperCase();
    }
  }
}

/// Enum for stat rating categories
enum StatRating { legendary, excellent, good, average, belowAverage }

/// Enum for individual stat quality
enum StatQuality { exceptional, great, good, average, low }
