/// String extensions for common transformations
extension StringExtensions on String {
  /// Capitalize the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Convert to title case (each word capitalized)
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Remove hyphens and convert to readable format
  /// e.g., "special-attack" -> "Special Attack"
  String get toReadable {
    return replaceAll('-', ' ').titleCase;
  }

  /// Extract ID from URL
  /// e.g., "https://pokeapi.co/api/v2/pokemon/25/" -> 25
  int? get extractIdFromUrl {
    final parts = split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    return int.tryParse(parts.last);
  }

  /// Convert stat name to short form
  String get toShortStatName {
    switch (toLowerCase()) {
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
        return toUpperCase();
    }
  }
}
