import 'package:flutter/material.dart';

/// Pokemon type colors - Official Pokemon type colors for UI styling
class PokemonTypeColors {
  const PokemonTypeColors._();

  static const Map<String, Color> typeColors = {
    'normal': Color(0xFFA8A878),
    'fire': Color(0xFFF08030),
    'water': Color(0xFF6890F0),
    'electric': Color(0xFFF8D030),
    'grass': Color(0xFF78C850),
    'ice': Color(0xFF98D8D8),
    'fighting': Color(0xFFC03028),
    'poison': Color(0xFFA040A0),
    'ground': Color(0xFFE0C068),
    'flying': Color(0xFFA890F0),
    'psychic': Color(0xFFF85888),
    'bug': Color(0xFFA8B820),
    'rock': Color(0xFFB8A038),
    'ghost': Color(0xFF705898),
    'dragon': Color(0xFF7038F8),
    'dark': Color(0xFF705848),
    'steel': Color(0xFFB8B8D0),
    'fairy': Color(0xFFEE99AC),
  };

  /// Darker variants for gradients
  static const Map<String, Color> typeDarkColors = {
    'normal': Color(0xFF6D6D4E),
    'fire': Color(0xFF9C531F),
    'water': Color(0xFF445E9C),
    'electric': Color(0xFFA1871F),
    'grass': Color(0xFF4E8234),
    'ice': Color(0xFF638D8D),
    'fighting': Color(0xFF7D1F1A),
    'poison': Color(0xFF682A68),
    'ground': Color(0xFF927D44),
    'flying': Color(0xFF6D5E9C),
    'psychic': Color(0xFFA13959),
    'bug': Color(0xFF6D7815),
    'rock': Color(0xFF786824),
    'ghost': Color(0xFF493963),
    'dragon': Color(0xFF4924A1),
    'dark': Color(0xFF49392F),
    'steel': Color(0xFF787887),
    'fairy': Color(0xFF9B6470),
  };

  /// Get color for a Pokemon type
  static Color getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? typeColors['normal']!;
  }

  /// Get dark color for a Pokemon type
  static Color getTypeDarkColor(String type) {
    return typeDarkColors[type.toLowerCase()] ?? typeDarkColors['normal']!;
  }

  /// Get gradient colors for a Pokemon type
  static List<Color> getTypeGradient(String type) {
    final color = getTypeColor(type);
    final darkColor = getTypeDarkColor(type);
    return [color, darkColor];
  }

  /// Get gradient colors for a Pokemon based on its types
  static List<Color> getPokemonGradient(List<String> types) {
    if (types.isEmpty) {
      return getTypeGradient('normal');
    }
    if (types.length == 1) {
      return getTypeGradient(types.first);
    }
    return [getTypeColor(types.first), getTypeColor(types.last)];
  }

  /// Get contrasting text color for a type background
  static Color getContrastingTextColor(String type) {
    final color = getTypeColor(type);
    // Calculate luminance to determine if we need light or dark text
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
