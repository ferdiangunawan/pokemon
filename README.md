# Pokémon App

A beautiful Pokemon encyclopedia app built with Flutter following Clean Architecture principles.

## Features

- 🎨 **Responsive Design** - Works in both portrait and landscape modes
- 🌙 **Day/Night Theme** - Toggle between light and dark themes
- 🌍 **Localization** - Supports English and Indonesian
- 📱 **Staggered Grid** - Creative Pokemon card layout
- 🔍 **Search** - Find Pokemon by name
- 📊 **Detailed Stats** - View Pokemon stats with animated bars
- 🧬 **Evolution Chain** - See complete evolution tree
- ⚡ **Moves List** - Browse all Pokemon moves

## Getting Started

### Prerequisites

- Flutter SDK ^3.8.0
- Dart SDK ^3.8.1

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   make get
   # or
   flutter pub get
   ```

3. Run the app:
   ```bash
   make run
   # or
   flutter run
   ```

## Makefile Commands

This project includes a Makefile with useful shortcuts. Run `make help` to see all available commands.

### Quick Reference

| Command | Description |
|---------|-------------|
| `make get` | Install dependencies |
| `make clean` | Clean and reinstall dependencies |
| `make run` | Run on default device |
| `make run-android` | Run on Android |
| `make run-ios` | Run on iOS |
| `make run-web` | Run on web |
| `make test` | Run all tests |
| `make test-coverage` | Run tests with coverage |
| `make analyze` | Run static analysis |
| `make format` | Format Dart code |

### Code Generation

| Command | Description |
|---------|-------------|
| `make gen-icons` | Generate launcher icons |
| `make gen-splash` | Generate native splash screen |
| `make gen-localization` | Generate localization keys |
| `make gen-all` | Generate all (icons + splash + localization) |

### Build Commands

| Command | Description |
|---------|-------------|
| `make build-apk` | Build Android APK |
| `make build-appbundle` | Build Android App Bundle |
| `make build-ios` | Build iOS |
| `make build-web` | Build for web |

## Code Generation

This project uses code generation for:

### 🎨 Launcher Icons

Configuration: `flutter_launcher_icons.yaml`

```bash
make gen-icons
# or
dart run flutter_launcher_icons
```

Generates app icons for Android, iOS, Web, Windows, and macOS from `assets/images/pokeball.png`.

### 💦 Native Splash Screen

Configuration: `flutter_native_splash.yaml`

```bash
make gen-splash
# or
dart run flutter_native_splash:create
```

Generates native splash screens with the Pokeball logo on a grey background.

### 🌍 Localization

Translation files: `assets/translations/en.json`, `assets/translations/id.json`

Generated keys: `lib/generated/locale_keys.g.dart`

The app uses [easy_localization](https://pub.dev/packages/easy_localization) for internationalization.

## Architecture

This project follows **Clean Architecture** with these layers:

- **Common** - Shared utilities and constants
- **Core** - Infrastructure (DI, Network, Router, Theme)
- **Data** - Models, DataSources, Repository implementations
- **Domain** - Entities and Repository interfaces
- **Presentation** - UI with BLoC/Cubit pattern

## Project Structure

```
lib/
├── common/           # Shared utilities
│   ├── constants/    # API constants, type colors
│   └── utils/        # ViewData, ReturnValue, extensions
├── core/             # App infrastructure
│   ├── di/           # Dependency injection
│   ├── network/      # Dio client with caching
│   ├── router/       # GoRouter configuration
│   └── theme/        # Light/dark themes
├── data/             # Data layer
│   ├── datasources/  # Remote data sources
│   ├── models/       # JSON models
│   └── repositories/ # Repository implementations
├── domain/           # Business logic
│   ├── entities/     # Pure Dart entities
│   └── repositories/ # Repository interfaces
├── presentation/     # UI layer
│   ├── home/         # Home feature
│   ├── detail/       # Pokemon detail feature
│   └── shared/       # Shared widgets
├── generated/        # Generated code (locale keys)
├── app.dart          # App widget
└── main.dart         # Entry point
```

## Dependencies

| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| dio | HTTP client |
| go_router | Navigation |
| get_it | Dependency injection |
| easy_localization | i18n |
| flutter_screenutil | Responsive sizing |
| cached_network_image | Image caching |
| flutter_staggered_grid_view | Grid layout |

### Dev Dependencies

| Package | Purpose |
|---------|---------|
| flutter_launcher_icons | App icon generation |
| flutter_native_splash | Splash screen generation |
| flutter_lints | Linting rules |

## Testing

Run unit tests:
```bash
make test
# or
flutter test
```

Run with coverage:
```bash
make test-coverage
# or
flutter test --coverage
```

## API

This app uses the [PokeAPI](https://pokeapi.co/) - a free RESTful Pokemon API.

## License

This project is for educational purposes.

