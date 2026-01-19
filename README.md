# Media Wipe

**Sort your photos, seamlessly.**

A Flutter mobile application designed to help users organize and safely delete photos and videos from their device. Media Wipe provides an intuitive swipe-based interface for quickly sorting through your media library and performing controlled deletions with built-in safety features.

## Features

### Media Management
- **Year/Month Browser** - Browse your photo library organized hierarchically by creation date
- **Swipe-based Sorting** - Interactive card interface for quick keep/delete decisions
- **Session Management** - Create sorting sessions to organize and track deletion decisions
- **Whitelist Refinement** - Narrow down selections after initial sorting with "refine" mode
- **Undo Functionality** - Revert last action within an active session
- **Summary View** - Review all selected items before committing to deletion
- **Dry Run Mode** - Test deletions without actually removing files from your device
- **Safe Deletion** - Permanently delete selected media with confirmation

### User Experience
- **Photo Access Authorization** - Seamless permission handling for device photo library
- **Theme Management** - Light/dark themes with system preference support
- **In-App Review** - Integrated app store review prompts
- **Settings Persistence** - Save user preferences locally
- **Localization** - Multi-language support infrastructure

## Architecture

This application follows **Clean Architecture** principles with an **MVCS** (Model-View-Controller-Services) pattern:

### Layers

- **MODEL** – Domain entities and business logic. Contains data models (Asset, Session, Settings) and rules for data validation and manipulation.

- **VIEW** – All Flutter Widgets and Pages that make up the UI. Views observe state changes and render accordingly.

- **CONTROLLER** – Application logic implemented through BLoCs and Cubits:
  - `MediaBloc` - Handles media operations (refresh, delete, authorization)
  - `SessionCubit` - Manages sorting session lifecycle and decisions
  - `SettingsCubit` - Controls app settings and preferences

- **SERVICES** – External data sources that fetch and persist data:
  - `photo_manager` - Access device photo library
  - `Isar` database - Local storage for metadata and sessions
  - Use cases orchestrate services and inject results into the model

### Project Structure

```
lib/
├── main.dart                 # Entry point with dependency injection setup
├── src/
│   ├── core/                 # Infrastructure layer
│   │   ├── database/         # Isar database configuration
│   │   ├── di/               # GetIt dependency injection
│   │   ├── routing/          # GoRouter navigation setup
│   │   ├── services/         # Shared services
│   │   └── constants/        # App-wide constants
│   ├── data/                 # Data access layer
│   │   ├── datasources/      # Local database access
│   │   ├── repositories/     # Repository implementations
│   │   └── local/models/     # Isar entities
│   ├── domain/               # Business logic layer
│   │   ├── entities/         # Core domain models
│   │   ├── repositories/     # Repository interfaces
│   │   └── usecases/         # Business operations
│   └── presentation/         # UI layer
│       └── features/
│           ├── media/        # Photo sorting feature
│           └── settings/     # App settings feature
```

## Technologies

### Core Dependencies
- **flutter_bloc** - State management using BLoC/Cubit pattern
- **go_router** - Modern declarative routing
- **provider** - Additional state management support
- **get_it** - Service locator for dependency injection

### Database & Storage
- **isar** - Fast embedded NoSQL database for local data
- **photo_manager** - Access and manage device photos/videos
- **path_provider** - Device directory access

### Media Handling
- **extended_image** - Advanced image display and caching
- **video_player** & **chewie** - Video playback with enhanced UI
- **exif** - EXIF metadata reading

### UI/UX
- **appinio_swiper** - Swipe card gestures for sorting interface
- **flutter_svg** - SVG asset support
- **flutter_launcher_icons** - App icon generation
- **flutter_native_splash** - Native splash screen

### Permissions & System
- **permission_handler** - Device permission management
- **url_launcher** - External URL handling
- **in_app_review** - App store review integration

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (bundled with Flutter)
- iOS development: Xcode and CocoaPods
- Android development: Android Studio and SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Isar database code:
   ```bash
   dart run build_runner build
   ```

4. Generate app icons:
   ```bash
   dart run flutter_launcher_icons
   ```

5. Run the application:
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Unit tests
flutter test

# Integration tests with Patrol
flutter test integration_test
```

## Assets

The `assets` directory contains:
- **images** - Resolution-aware images including app icons and UI elements
- **fonts** - Custom fonts (if applicable)

## Localization

This project supports internationalization based on ARB files in `lib/src/localization/`.

To add support for additional languages:
1. Create a new ARB file (e.g., `app_es.arb` for Spanish)
2. Add translations for all keys
3. Run code generation: `flutter gen-l10n`

For more information, see the [Flutter internationalization guide](https://flutter.dev/docs/development/accessibility-and-localization/internationalization).

## Development

### State Management Philosophy
- Use **BLoC** for complex state with events and multiple state transitions
- Use **Cubit** for simpler state management with direct state emissions
- Register as factories in DI container for proper lifecycle management

### Code Generation
Run code generation after modifying:
- Isar entities (annotated with `@collection`)
- Localization ARB files

```bash
dart run build_runner build --delete-conflicting-outputs
```

## License

This project is a personal application. Please contact the author for licensing information.

## Contributing

This is a personal project. If you'd like to contribute or report issues, please contact the repository owner.
