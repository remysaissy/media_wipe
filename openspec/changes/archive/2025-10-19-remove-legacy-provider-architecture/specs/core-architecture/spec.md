# Core Architecture - Legacy Removal

## REMOVED Requirements

### Requirement: Provider-based State Management
**Reason**: Replaced by BLoC/Cubit state management pattern as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**: All Provider models (`asset_model.dart`, `sessions_model.dart`, `settings_model.dart`) have been replaced with BLoCs and Cubits (`MediaBloc`, `SessionCubit`, `SettingsCubit`). Code using `Provider.of<T>()` or `context.watch<T>()` should now use `BlocProvider.of<T>()` or `context.read<T>()/context.watch<T>()` from flutter_bloc.

#### Scenario: State management access removed
- **WHEN** code tries to import Provider models from `lib/assets/models/asset_model.dart`, `lib/assets/models/sessions_model.dart`, or `lib/settings/models/settings_model.dart`
- **THEN** import fails as files no longer exist

### Requirement: Command Pattern for Business Logic
**Reason**: Replaced by Use Case pattern in Clean Architecture as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**: All Command classes have been replaced with Use Cases in `lib/src/domain/usecases/`. Commands like `RefreshPhotosCommand` are now `RefreshPhotosUseCase`. The execution pattern changes from `command.execute()` to `useCase.execute()`, with BLoCs/Cubits orchestrating use case calls.

#### Scenario: Command imports removed
- **WHEN** code tries to import commands from `lib/assets/commands/` or `lib/settings/commands/`
- **THEN** import fails as command files no longer exist

### Requirement: Legacy Data Models
**Reason**: Replaced by separated domain entities and data models as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**:
- `lib/assets/models/asset.dart` → `lib/src/domain/entities/asset.dart` (domain) and `lib/src/data/local/models/asset_entity.dart` (data)
- `lib/assets/models/session.dart` → `lib/src/domain/entities/session.dart` (domain) and `lib/src/data/local/models/session_entity.dart` (data)
- `lib/settings/models/settings.dart` → `lib/src/domain/entities/settings.dart` (domain) and `lib/src/data/local/models/settings_entity.dart` (data)

#### Scenario: Legacy model imports removed
- **WHEN** code tries to import from `lib/assets/models/asset.dart`, `lib/assets/models/session.dart`, or `lib/settings/models/settings.dart`
- **THEN** import fails as files no longer exist

### Requirement: Feature-based Routers
**Reason**: Consolidated into single `AppRouter` class as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**: All routing logic from `lib/assets/router.dart`, `lib/settings/router.dart`, and `lib/shared/router.dart` has been consolidated into `lib/src/core/routing/app_router.dart`. Route definitions remain the same.

#### Scenario: Legacy router imports removed
- **WHEN** code tries to import routers from `lib/assets/router.dart`, `lib/settings/router.dart`, or `lib/shared/router.dart`
- **THEN** import fails as files no longer exist

### Requirement: Legacy Shared Infrastructure
**Reason**: Moved to Clean Architecture directory structure under `lib/src/core/` as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**:
- `lib/shared/models/datastore.dart` → `lib/src/core/database/datastore.dart`
- `lib/shared/app.dart` → `lib/src/presentation/app.dart`
- `lib/shared/constants.dart` → `lib/src/core/constants/app_constants.dart`
- `lib/shared/utils.dart` → `lib/src/core/utils/app_utils.dart`
- `lib/shared/theme.dart` → `lib/src/presentation/shared/theme.dart`
- `lib/shared/views/loading_view.dart` → `lib/src/presentation/shared/views/loading_view.dart`

#### Scenario: Legacy shared imports removed
- **WHEN** code tries to import from `lib/shared/` directory
- **THEN** import fails as files have been moved to new locations

### Requirement: Legacy Views and Widgets
**Reason**: Migrated to Clean Architecture structure under `lib/src/presentation/` with BLoC integration as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**: All views and widgets from `lib/assets/views/`, `lib/assets/widgets/`, `lib/settings/views/`, and `lib/settings/widgets/` have been migrated to `lib/src/presentation/features/{media,settings}/` with BLoC state management integration. Stub implementations exist in new locations.

#### Scenario: Legacy view imports removed
- **WHEN** code tries to import views from `lib/assets/views/` or `lib/settings/views/`
- **THEN** import fails as files have been moved to new feature-based structure

#### Scenario: Legacy widget imports removed
- **WHEN** code tries to import widgets from `lib/assets/widgets/` or `lib/settings/widgets/`
- **THEN** import fails as files have been moved to new feature-based structure

### Requirement: Legacy Directory Structure
**Reason**: Replaced with Clean Architecture layered structure (`presentation/domain/data`) as specified in `refactor-architecture-to-clean-mvvm`.

**Migration**: All code from `lib/assets/`, `lib/settings/`, and `lib/shared/` directories has been restructured under `lib/src/` with proper layer separation. The new structure follows:
- `lib/src/presentation/` - UI layer (views, widgets, BLoCs)
- `lib/src/domain/` - Business logic layer (entities, use cases, repository interfaces)
- `lib/src/data/` - Data layer (data sources, repository implementations, data models)
- `lib/src/core/` - Cross-cutting concerns (DI, routing, database, constants, utils)

#### Scenario: Legacy directories removed
- **WHEN** developer navigates file structure
- **THEN** `lib/assets/`, `lib/settings/`, and `lib/shared/` directories no longer exist
