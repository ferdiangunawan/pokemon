/// Helper class for Pokemon formatting operations
class PokemonFormatHelper {
  const PokemonFormatHelper._();

  /// Format Pokemon ID with leading zeros (e.g., 25 -> "025")
  static String formatPokemonId(int id, {int digits = 3}) {
    return id.toString().padLeft(digits, '0');
  }

  /// Format height from decimeters to meters (e.g., 4 -> "0.4 m")
  static String formatHeight(int heightInDecimeters) {
    final meters = heightInDecimeters / 10.0;
    return '${meters.toStringAsFixed(1)} m';
  }

  /// Format weight from hectograms to kilograms (e.g., 60 -> "6.0 kg")
  static String formatWeight(int weightInHectograms) {
    final kg = weightInHectograms / 10.0;
    return '${kg.toStringAsFixed(1)} kg';
  }

  /// Convert height from decimeters to meters
  static double heightToMeters(int heightInDecimeters) {
    return heightInDecimeters / 10.0;
  }

  /// Convert weight from hectograms to kilograms
  static double weightToKg(int weightInHectograms) {
    return weightInHectograms / 10.0;
  }

  /// Format percentage value (e.g., 50.5 -> "50.5%")
  static String formatPercentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Calculate male ratio from gender rate
  /// Gender rate is -1 for genderless, 0-8 for male/female ratio
  /// Rate of 0 = 100% male, Rate of 8 = 100% female
  static double calculateMaleRatio(int genderRate) {
    if (genderRate < 0) return 0.0; // Genderless
    return (8 - genderRate) / 8.0 * 100.0;
  }

  /// Calculate female ratio from gender rate
  static double calculateFemaleRatio(int genderRate) {
    if (genderRate < 0) return 0.0; // Genderless
    return genderRate / 8.0 * 100.0;
  }

  /// Check if Pokemon is genderless based on gender rate
  static bool isGenderless(int genderRate) {
    return genderRate < 0;
  }
}
