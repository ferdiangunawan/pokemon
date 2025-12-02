import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/index.dart';
import '../../domain/index.dart';
import '../../presentation/index.dart';
import '../network/index.dart';
import '../theme/index.dart';

final GetIt getIt = GetIt.instance;

/// Setup all dependencies for the app
Future<void> setupDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core - Network Client
  getIt.registerSingletonAsync<NetworkClient>(() async {
    final client = NetworkClient();
    await client.initialize();
    return client;
  });
  await getIt.isReady<NetworkClient>();

  // Theme Cubit
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<SharedPreferences>())..loadTheme(),
  );

  // Data Sources
  getIt.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSource(getIt<NetworkClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(getIt<PokemonRemoteDataSource>()),
  );

  // Cubits - Factory pattern (new instance each time)
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<PokemonRepository>()));

  getIt.registerFactory<PokemonDetailCubit>(
    () => PokemonDetailCubit(getIt<PokemonRepository>()),
  );
}
