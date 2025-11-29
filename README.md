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
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

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

## Testing

Run unit tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## API

This app uses the [PokeAPI](https://pokeapi.co/) - a free RESTful Pokemon API.

