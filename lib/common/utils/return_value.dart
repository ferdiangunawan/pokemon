import 'dart:developer' as dev;

/// Utility class for safe JSON parsing and type conversion
///
/// Provides type-safe methods to extract values from JSON maps with proper
/// error handling, null safety, and default values.
///
/// Example usage:
/// ```dart
/// final pokemon = Pokemon(
///   id: ReturnValue.integer(json['id'])!,
///   name: ReturnValue.string(json['name'])!,
///   height: ReturnValue.integer(json['height'], nullable: true),
///   types: ReturnValue.list<String>(json['types'], nullable: true),
/// );
/// ```
class ReturnValue {
  const ReturnValue._();

  /// Safely extracts a string value from JSON
  static String? string(
    dynamic value, {
    String defaultValue = '',
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : defaultValue;
      }

      if (value is String) {
        return value;
      }

      if (value is num) {
        return value.toString();
      }

      if (value is bool) {
        return value.toString();
      }

      return value.toString();
    } catch (e) {
      _logError('string', value, e);
      return nullable ? null : defaultValue;
    }
  }

  /// Safely extracts an integer value from JSON
  static int? integer(
    dynamic value, {
    int defaultValue = 0,
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : defaultValue;
      }

      if (value is int) {
        return value;
      }

      if (value is double) {
        return value.toInt();
      }

      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? (nullable ? null : defaultValue);
      }

      if (value is bool) {
        return value ? 1 : 0;
      }

      return nullable ? null : defaultValue;
    } catch (e) {
      _logError('integer', value, e);
      return nullable ? null : defaultValue;
    }
  }

  /// Safely extracts a double value from JSON
  static double? decimal(
    dynamic value, {
    double defaultValue = 0.0,
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : defaultValue;
      }

      if (value is double) {
        return value;
      }

      if (value is int) {
        return value.toDouble();
      }

      if (value is String) {
        final parsed = double.tryParse(value);
        return parsed ?? (nullable ? null : defaultValue);
      }

      return nullable ? null : defaultValue;
    } catch (e) {
      _logError('decimal', value, e);
      return nullable ? null : defaultValue;
    }
  }

  /// Safely extracts a boolean value from JSON
  static bool? boolean(
    dynamic value, {
    bool defaultValue = false,
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : defaultValue;
      }

      if (value is bool) {
        return value;
      }

      if (value is int) {
        return value != 0;
      }

      if (value is String) {
        final lowerValue = value.toLowerCase();
        if (lowerValue == 'true' || lowerValue == '1' || lowerValue == 'yes') {
          return true;
        }
        if (lowerValue == 'false' || lowerValue == '0' || lowerValue == 'no') {
          return false;
        }
      }

      return nullable ? null : defaultValue;
    } catch (e) {
      _logError('boolean', value, e);
      return nullable ? null : defaultValue;
    }
  }

  /// Safely extracts a list of primitive values from JSON
  static List<T>? list<T>(
    dynamic value, {
    List<T> defaultValue = const [],
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : List<T>.from(defaultValue);
      }

      if (value is List) {
        if (T == double) {
          return value.map((e) => (e as num).toDouble()).toList() as List<T>;
        }
        if (T == int) {
          return value.map((e) => (e as num).toInt()).toList() as List<T>;
        }
        if (T == num) {
          return value.cast<num>() as List<T>;
        }
        return value.cast<T>();
      }

      if (value is T) {
        return [value];
      }

      if (T == double && value is num) {
        return [value.toDouble() as T];
      }
      if (T == int && value is num) {
        return [value.toInt() as T];
      }

      return nullable ? null : List<T>.from(defaultValue);
    } catch (e) {
      _logError('list<$T>', value, e);
      return nullable ? null : List<T>.from(defaultValue);
    }
  }

  /// Safely extracts a list of objects from JSON using a factory function
  static List<T>? listOfObjects<T>(
    dynamic value,
    T Function(Map<String, dynamic>) factory, {
    List<T> defaultValue = const [],
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : List<T>.from(defaultValue);
      }

      if (value is List) {
        final List<T> result = [];
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            try {
              result.add(factory(item));
            } catch (e) {
              _logError('listOfObjects factory', item, e);
            }
          }
        }
        return result;
      }

      if (value is Map<String, dynamic>) {
        try {
          return [factory(value)];
        } catch (e) {
          _logError('listOfObjects single factory', value, e);
        }
      }

      return nullable ? null : List<T>.from(defaultValue);
    } catch (e) {
      _logError('listOfObjects<$T>', value, e);
      return nullable ? null : List<T>.from(defaultValue);
    }
  }

  /// Safely extracts a single object from JSON using a factory function
  static T? object<T>(
    dynamic value,
    T Function(Map<String, dynamic>) factory, {
    T? defaultValue,
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : defaultValue;
      }

      if (value is Map<String, dynamic>) {
        return factory(value);
      }

      return nullable ? null : defaultValue;
    } catch (e) {
      _logError('object<$T>', value, e);
      return nullable ? null : defaultValue;
    }
  }

  /// Safely extracts a Map<String, dynamic> from JSON
  static Map<String, dynamic>? map(
    dynamic value, {
    Map<String, dynamic> defaultValue = const {},
    bool nullable = false,
  }) {
    try {
      if (value == null) {
        return nullable ? null : Map<String, dynamic>.from(defaultValue);
      }

      if (value is Map<String, dynamic>) {
        return value;
      }

      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }

      return nullable ? null : Map<String, dynamic>.from(defaultValue);
    } catch (e) {
      _logError('map', value, e);
      return nullable ? null : Map<String, dynamic>.from(defaultValue);
    }
  }

  static void _logError(String type, dynamic value, Object error) {
    dev.log(
      'ReturnValue.$type parsing error: $error',
      name: 'ReturnValue',
      error: error,
      level: 900,
    );
    dev.log(
      'Failed to parse value: $value (${value.runtimeType})',
      name: 'ReturnValue',
      level: 900,
    );
  }
}
