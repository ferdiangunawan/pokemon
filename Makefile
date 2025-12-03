# Pokémon App Makefile
# Shortcuts for common Flutter development tasks

.PHONY: help clean get build run test analyze format \
        gen-icons gen-splash gen-localization gen-all \
        build-android build-ios build-web build-apk build-appbundle \
        run-android run-ios run-web run-chrome \
        test-coverage watch

# Default target - show help
help:
	@echo "╔══════════════════════════════════════════════════════════════════╗"
	@echo "║                     Pokémon App - Makefile                       ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║ SETUP & DEPENDENCIES                                             ║"
	@echo "║   make get              - Install dependencies (flutter pub get) ║"
	@echo "║   make clean            - Clean build artifacts                  ║"
	@echo "║   make upgrade          - Upgrade dependencies                   ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║ CODE GENERATION                                                  ║"
	@echo "║   make gen-icons        - Generate launcher icons                ║"
	@echo "║   make gen-splash       - Generate native splash screen          ║"
	@echo "║   make gen-localization - Generate localization keys             ║"
	@echo "║   make gen-all          - Generate all (icons + splash + l10n)   ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║ RUN APP                                                          ║"
	@echo "║   make run              - Run on default device                  ║"
	@echo "║   make run-android      - Run on Android device/emulator         ║"
	@echo "║   make run-ios          - Run on iOS device/simulator            ║"
	@echo "║   make run-web          - Run on web (default browser)           ║"
	@echo "║   make run-chrome       - Run on Chrome                          ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║ BUILD                                                            ║"
	@echo "║   make build-apk        - Build Android APK                      ║"
	@echo "║   make build-appbundle  - Build Android App Bundle               ║"
	@echo "║   make build-ios        - Build iOS                              ║"
	@echo "║   make build-web        - Build for web                          ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║ TESTING & QUALITY                                                ║"
	@echo "║   make test             - Run all tests                          ║"
	@echo "║   make test-coverage    - Run tests with coverage                ║"
	@echo "║   make analyze          - Run static analysis                    ║"
	@echo "║   make format           - Format Dart code                       ║"
	@echo "║   make check            - Run analyze + format check             ║"
	@echo "╠══════════════════════════════════════════════════════════════════╣"
	@echo "║ UTILITIES                                                        ║"
	@echo "║   make devices          - List available devices                 ║"
	@echo "║   make doctor           - Run Flutter doctor                     ║"
	@echo "║   make outdated         - Check for outdated packages            ║"
	@echo "╚══════════════════════════════════════════════════════════════════╝"

# ============================================================================
# SETUP & DEPENDENCIES
# ============================================================================

## Install dependencies
get:
	@echo "📦 Installing dependencies..."
	flutter pub get

## Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	flutter clean
	@echo "📦 Reinstalling dependencies..."
	flutter pub get

## Upgrade dependencies
upgrade:
	@echo "⬆️  Upgrading dependencies..."
	flutter pub upgrade

# ============================================================================
# CODE GENERATION
# ============================================================================

## Generate launcher icons (uses flutter_launcher_icons.yaml)
gen-icons:
	@echo "🎨 Generating launcher icons..."
	dart run flutter_launcher_icons

## Generate native splash screen (uses flutter_native_splash.yaml)
gen-splash:
	@echo "💦 Generating native splash screen..."
	dart run flutter_native_splash:create

## Generate localization keys from assets/translations/*.json
gen-localization:
	@echo "🌍 Generating localization keys..."
	@echo "// Generated file - do not edit manually" > lib/generated/locale_keys.g.dart
	@echo "// Run 'make gen-localization' to regenerate" >> lib/generated/locale_keys.g.dart
	@echo "" >> lib/generated/locale_keys.g.dart
	@dart run scripts/generate_locale_keys.dart 2>/dev/null || \
		echo "ℹ️  Using easy_localization - keys are loaded at runtime from assets/translations/"

## Generate all code (icons + splash + localization)
gen-all: gen-icons gen-splash gen-localization
	@echo "✅ All code generation completed!"

# ============================================================================
# RUN APP
# ============================================================================

## Run on default device
run:
	@echo "🚀 Running app..."
	flutter run

## Run on Android device/emulator
run-android:
	@echo "🤖 Running on Android..."
	flutter run -d android

## Run on iOS device/simulator
run-ios:
	@echo "🍎 Running on iOS..."
	flutter run -d ios

## Run on web (default browser)
run-web:
	@echo "🌐 Running on web..."
	flutter run -d web-server

## Run on Chrome
run-chrome:
	@echo "🌐 Running on Chrome..."
	flutter run -d chrome

# ============================================================================
# BUILD
# ============================================================================

## Build Android APK
build-apk:
	@echo "📦 Building Android APK..."
	flutter build apk --release

## Build Android App Bundle
build-appbundle:
	@echo "📦 Building Android App Bundle..."
	flutter build appbundle --release

## Build iOS
build-ios:
	@echo "📦 Building iOS..."
	flutter build ios --release

## Build for web
build-web:
	@echo "📦 Building for web..."
	flutter build web --release

# ============================================================================
# TESTING & QUALITY
# ============================================================================

## Run all tests
test:
	@echo "🧪 Running tests..."
	flutter test

## Run tests with coverage
test-coverage:
	@echo "🧪 Running tests with coverage..."
	flutter test --coverage
	@echo "📊 Coverage report generated at coverage/lcov.info"

## Run static analysis
analyze:
	@echo "🔍 Running static analysis..."
	flutter analyze

## Format Dart code
format:
	@echo "✨ Formatting Dart code..."
	dart format lib test

## Run analyze + format check
check:
	@echo "🔍 Running quality checks..."
	flutter analyze
	dart format --set-exit-if-changed lib test

# ============================================================================
# UTILITIES
# ============================================================================

## List available devices
devices:
	@echo "📱 Available devices:"
	flutter devices

## Run Flutter doctor
doctor:
	@echo "🏥 Running Flutter doctor..."
	flutter doctor -v

## Check for outdated packages
outdated:
	@echo "📋 Checking for outdated packages..."
	flutter pub outdated
