# Design Document: Clean Architecture MVVM Refactoring

## Context

The current codebase implements a Provider-based architecture with ChangeNotifier models and a Command pattern for business logic. The project conventions mandate Clean Architecture with MVVM using BLoC/Cubit for state management. This design document outlines the technical decisions and migration approach for this comprehensive refactoring.

**Current State:**
- 60 Dart files in flat directory structure
- Provider + ChangeNotifier for state management
- Command pattern for business logic (13 command files)
- Direct coupling between UI and data layer
- 4 existing tests

**Target State:**
- Clean Architecture with three distinct layers
- BLoC/Cubit state management
- MVVM pattern with BLoCs as ViewModels
- get_it for dependency injection
- Repository pattern for data abstraction
- Comprehensive test coverage (70/20/10)

## Goals / Non-Goals

### Goals
- Align codebase 100% with project conventions in `openspec/project.md`
- Establish clear separation of concerns across presentation/domain/data layers
- Make business logic testable and independent of Flutter framework
- Implement proper dependency injection with get_it
- Enable scalable architecture for future features
- Maintain feature parity with current implementation

### Non-Goals
- Adding new features during refactoring
- Performance optimization (maintain current performance baseline)
- UI/UX redesign
- Changing ObjectBox database schema
- Modifying external package dependencies (except adding flutter_bloc and get_it)

## Decisions

### 1. Directory Structure

**Decision**: Adopt Clean Architecture three-layer structure under `lib/src/`

```
lib/
├── src/
│   ├── presentation/        # UI layer
│   │   ├── features/
│   │   │   ├── media/
│   │   │   │   ├── blocs/
│   │   │   │   ├── views/
│   │   │   │   └── widgets/
│   │   │   └── settings/
│   │   │       ├── blocs/
│   │   │       ├── views/
│   │   │       └── widgets/
│   │   ├── shared/
│   │   └── app.dart
│   ├── domain/              # Business logic layer
│   │   ├── entities/
│   │   ├── repositories/    # Abstract interfaces
│   │   └── usecases/
│   ├── data/                # Data access layer
│   │   ├── models/          # ObjectBox entities
│   │   ├── datasources/
│   │   └── repositories/    # Implementations
│   └── core/
│       ├── di/
│       ├── database/
│       ├── routing/
│       └── services/
├── main.dart
└── objectbox.g.dart
```

**Rationale**:
- Enforces separation of concerns
- Matches project conventions exactly
- Makes dependency flow explicit (Presentation → Domain → Data)
- Improves testability by isolating layers

**Alternatives Considered**:
- Feature-first structure: Rejected because project conventions explicitly specify Clean Architecture
- Keep flat structure with only state management changes: Rejected because it doesn't achieve full alignment

### 2. State Management Migration

**Decision**: Replace Provider + ChangeNotifier with flutter_bloc package using BLoCs/Cubits

**Mapping Strategy**:
- `AssetsModel` → `MediaBloc` (complex state with events)
- `SessionsModel` → `SessionCubit` (simpler state)
- `SettingsModel` → `SettingsCubit` (simple state)

**Rationale**:
- BLoC pattern explicitly required in project conventions
- Better testability with clear event/state separation
- Traceable state changes for debugging
- Industry standard for Flutter enterprise apps

**Alternatives Considered**:
- Riverpod: Rejected - not mentioned in project conventions
- Keep Provider: Rejected - doesn't meet project requirements

### 3. Command Pattern Migration

**Decision**: Eliminate Command pattern, distribute logic between BLoCs and Use Cases

**Migration Strategy**:
```
Commands → Use Cases (domain) + BLoC Events (presentation)

Example:
- RefreshPhotosCommand → RefreshPhotosUseCase + RefreshMediaEvent
- DeleteAssetsCommand → DeleteAssetsUseCase + DeleteMediaEvent
- UpdateThemeCommand → UpdateThemeEvent (Cubit method)
```

**Rationale**:
- Commands violate Clean Architecture (mix UI context with business logic)
- Use Cases provide pure business logic without Flutter dependencies
- BLoC events provide UI-triggered actions
- Aligns with MVVM pattern (BLoC as ViewModel)

### 4. Dependency Injection

**Decision**: Replace Provider-based DI with get_it service locator

**Setup Location**: `lib/src/core/di/injection_container.dart`

**Registration Strategy**:
```dart
// Singletons for services and data sources
getIt.registerLazySingleton<Datastore>(() => Datastore.getInstance());
getIt.registerLazySingleton<AssetRepository>(() => AssetRepositoryImpl(...));

// Factory for BLoCs (new instance per request)
getIt.registerFactory<MediaBloc>(() => MediaBloc(...));
```

**Rationale**:
- Explicitly required in project conventions
- Better control over lifecycle
- Easier to test with mock injection
- Decouples component creation from usage

### 5. Repository Pattern

**Decision**: Introduce Repository interfaces in domain layer, implementations in data layer

**Example**:
```dart
// domain/repositories/asset_repository.dart (abstract)
abstract class AssetRepository {
  Future<List<Asset>> getAssets({int? year, int? month});
  Future<void> deleteAssets(List<String> ids);
}

// data/repositories/asset_repository_impl.dart (concrete)
class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource dataSource;
  // Implementation
}
```

**Rationale**:
- Explicitly required in project conventions
- Abstracts data source details from business logic
- Enables easy mocking for tests
- Supports future addition of remote data sources

### 6. Entity vs Model Split

**Decision**: Domain entities separate from ObjectBox models

**Approach**:
- `data/models/*_entity.dart` - ObjectBox annotated classes
- `domain/entities/*.dart` - Pure Dart classes (no ObjectBox dependency)
- Mappers convert between them in repository implementations

**Rationale**:
- Domain layer must be framework-agnostic
- ObjectBox annotations pollute domain models
- Enables domain logic to be tested without database

**Trade-off**: Additional boilerplate for mapping, but gains clean architecture benefits

### 7. Testing Strategy

**Decision**: Implement 70/20/10 testing ratio as specified in project conventions

**Test Distribution**:
- **70% Unit Tests**: BLoCs, Use Cases, Repositories (with mocks)
- **20% Integration Tests**: Widget tests, feature flows
- **10% E2E Tests**: Full app flows using flutter_driver or patrol

**Tool Selection**:
- Unit: mockito for mocking
- Integration: flutter_test with widget tests
- E2E: patrol (better than flutter_driver)

**Rationale**: Follows project conventions exactly

### 8. Migration Execution

**Decision**: Big-bang migration with temporary feature gaps

**Approach**:
1. Create new directory structure alongside old code
2. Implement core architecture (DI, repositories, data sources)
3. Implement domain layer (entities, use cases)
4. Implement presentation layer (BLoCs, views, widgets)
5. Replace main.dart with new initialization
6. Delete old code
7. Write tests throughout

**Rationale**:
- User accepted temporary feature gaps
- Cleaner than incremental migration with two architectures coexisting
- Faster to complete
- No need for adapter patterns

**Alternatives Considered**:
- Strangler Fig pattern: Rejected - adds complexity with two architectures running simultaneously

## Risks / Trade-offs

### Risk 1: Extended Development Time
**Impact**: High (60 files to refactor)
**Mitigation**:
- Focus on mechanical refactoring, not feature changes
- Clear task breakdown in tasks.md
- Reuse existing business logic

### Risk 2: Introduction of Bugs
**Impact**: High (complete rewrite)
**Mitigation**:
- Comprehensive test coverage written alongside refactoring
- Preserve existing business logic exactly
- Manual QA testing before deployment

### Risk 3: Learning Curve for BLoC Pattern
**Impact**: Medium
**Mitigation**:
- BLoC is well-documented industry standard
- Clear examples in codebase after refactoring
- Follows project conventions team has already agreed to

### Risk 4: Temporary Feature Gaps
**Impact**: Medium (accepted by user)
**Mitigation**:
- Complete refactoring in a single branch
- Thorough testing before merge
- Clear deployment timeline

### Trade-off 1: Boilerplate Code
**Trade**: More files and boilerplate (entities, mappers, use cases)
**Gain**: Testability, maintainability, scalability, alignment with conventions

### Trade-off 2: Complexity
**Trade**: More architectural layers
**Gain**: Separation of concerns, easier to test individual layers, clearer dependencies

## Migration Plan

### Phase 1: Infrastructure Setup
1. Add dependencies: flutter_bloc, get_it
2. Create directory structure
3. Setup get_it injection container
4. Migrate Datastore to core/database

### Phase 2: Data Layer
1. Create ObjectBox entity models in data/models
2. Create data sources (convert services)
3. Create repository interfaces in domain
4. Create repository implementations in data

### Phase 3: Domain Layer
1. Create domain entities
2. Create use cases (from commands)
3. Setup entity mappers

### Phase 4: Presentation Layer
1. Create BLoCs/Cubits (from models)
2. Create states and events
3. Migrate views with BlocProvider/BlocBuilder
4. Migrate widgets

### Phase 5: Routing & App Initialization
1. Consolidate routers into single app_router.dart
2. Rewrite main.dart with get_it setup
3. Update app.dart

### Phase 6: Testing
1. Write unit tests for use cases, repositories, BLoCs
2. Write integration tests for feature flows
3. Write E2E tests for critical paths

### Phase 7: Cleanup
1. Delete old code (commands, old models, old structure)
2. Update imports across codebase
3. Verify all tests pass

## Open Questions

None - user has provided clear direction:
- ✅ Big-bang migration
- ✅ All architectural aspects simultaneously
- ✅ Accept temporary feature gaps
- ✅ Write tests alongside refactoring
