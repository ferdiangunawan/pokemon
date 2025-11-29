import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/index.dart';
import 'app.dart';

/// Main entry point for the Pokemon app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize dependency injection
  await setupDependencies();

  // Set preferred orientations (allow both portrait and landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const PokemonApp(),
    ),
  );
}
