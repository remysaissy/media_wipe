# core-architecture Specification

## Purpose
TBD - created by archiving change refactor-architecture-to-clean-mvvm. Update Purpose after archive.
## Requirements
### Requirement: Clean Architecture Layer Structure
The application SHALL organize code into three distinct layers following Clean Architecture principles: Presentation, Domain, and Data layers.

#### Scenario: Directory structure matches convention
- **WHEN** navigating the codebase
- **THEN** code is organized under `lib/src/` with separate `presentation/`, `domain/`, and `data/` directories
- **AND** each layer contains only appropriate components for its responsibility

#### Scenario: Dependency flow is unidirectional
- **WHEN** importing modules across layers
- **THEN** Presentation layer MAY import from Domain layer
- **AND** Domain layer MAY import from Data layer interfaces only
- **AND** Data layer MUST NOT import from Presentation layer
- **AND** Domain layer MUST NOT import from Presentation layer

### Requirement: Dependency Injection with get_it
The application SHALL use get_it service locator for dependency injection instead of Provider.

#### Scenario: Dependencies registered at startup
- **WHEN** application initializes
- **THEN** all services, repositories, data sources, and BLoCs are registered in `lib/src/core/di/injection_container.dart`
- **AND** singletons are used for services and data sources
- **AND** factories are used for BLoCs

#### Scenario: Dependencies resolved through get_it
- **WHEN** a component needs a dependency
- **THEN** it retrieves the dependency using `getIt<Type>()`
- **AND** it does NOT use Provider.of<Type>()

### Requirement: MVVM Architecture Pattern
The application SHALL follow the Model-View-ViewModel (MVVM) architectural pattern where BLoCs/Cubits act as ViewModels.

#### Scenario: Clear separation of concerns
- **WHEN** implementing a feature
- **THEN** Views (Widgets) contain only UI code and user interaction handlers
- **AND** ViewModels (BLoCs/Cubits) contain presentation logic and state management
- **AND** Models (Entities) contain business data structures

#### Scenario: Views depend on ViewModels
- **WHEN** a View needs data or business logic
- **THEN** it accesses data through a BLoC or Cubit
- **AND** it does NOT directly access repositories or use cases

### Requirement: BLoC State Management
The application SHALL use the BLoC (Business Logic Component) pattern via flutter_bloc package for state management.

#### Scenario: Complex state with BLoC
- **WHEN** a feature has complex state with traceable events
- **THEN** it uses a `Bloc` with explicit events and states
- **AND** events trigger state transitions
- **AND** state changes emit new states

#### Scenario: Simple state with Cubit
- **WHEN** a feature has simple state without complex event handling
- **THEN** it uses a `Cubit` with direct methods
- **AND** methods emit new states directly

#### Scenario: BLoCs located in presentation layer
- **WHEN** organizing BLoCs and Cubits
- **THEN** they are placed in `lib/src/presentation/features/[feature]/blocs/` or `cubits/`
- **AND** each BLoC has separate files for state and event definitions

### Requirement: Repository Pattern
The application SHALL implement the Repository pattern to abstract data access from business logic.

#### Scenario: Abstract repository interfaces in domain layer
- **WHEN** defining data access contracts
- **THEN** abstract repository interfaces are defined in `lib/src/domain/repositories/`
- **AND** interfaces define data operations without implementation details

#### Scenario: Concrete repository implementations in data layer
- **WHEN** implementing data access
- **THEN** concrete repository classes are in `lib/src/data/repositories/`
- **AND** implementations use data sources to access ObjectBox or other storage
- **AND** implementations map between data models and domain entities

#### Scenario: Use cases depend on repository interfaces
- **WHEN** use cases need data access
- **THEN** they depend on abstract repository interfaces from domain layer
- **AND** they do NOT directly depend on data layer implementations

### Requirement: Domain Entity and Data Model Separation
The application SHALL maintain separate entity classes in the domain layer and model classes in the data layer.

#### Scenario: Domain entities are framework-agnostic
- **WHEN** defining domain entities
- **THEN** entities are pure Dart classes in `lib/src/domain/entities/`
- **AND** entities have NO ObjectBox annotations
- **AND** entities have NO Flutter framework dependencies

#### Scenario: Data models have persistence annotations
- **WHEN** defining data models
- **THEN** models are in `lib/src/data/local/models/` with ObjectBox annotations
- **AND** models represent database schema

#### Scenario: Mappers convert between entities and models
- **WHEN** retrieving or storing data
- **THEN** repository implementations use mapper functions to convert between data models and domain entities
- **AND** mapping logic is encapsulated in repository implementations

### Requirement: Use Case Pattern
The application SHALL encapsulate business logic in use case classes that are independent of UI and data sources.

#### Scenario: Use cases contain single business operations
- **WHEN** implementing business logic
- **THEN** each use case represents one business operation
- **AND** use cases are placed in `lib/src/domain/usecases/[feature]/`
- **AND** use cases are pure Dart classes with no Flutter dependencies

#### Scenario: Use cases called by BLoCs
- **WHEN** a BLoC needs to execute business logic
- **THEN** it calls appropriate use cases
- **AND** it passes domain entities to use cases
- **AND** it receives domain entities from use cases

### Requirement: Testing Strategy Compliance
The application SHALL implement a comprehensive test suite following the 70/20/10 ratio: 70% unit tests, 20% integration tests, 10% end-to-end tests.

#### Scenario: Unit tests for isolated components
- **WHEN** writing unit tests
- **THEN** they test BLoCs, use cases, repositories, and utility functions in isolation
- **AND** they use mocks for dependencies
- **AND** they are placed in `test/` directory mirroring `lib/` structure
- **AND** they represent 70% of total tests

#### Scenario: Integration tests for component interactions
- **WHEN** writing integration tests
- **THEN** they test interactions between multiple components
- **AND** they include widget tests for screens and flows
- **AND** they are placed in `test/integration/` directory
- **AND** they represent 20% of total tests

#### Scenario: End-to-end tests for user flows
- **WHEN** writing E2E tests
- **THEN** they test complete user journeys
- **AND** they use flutter_driver or patrol to drive the application
- **AND** they are placed in `integration_test/` directory
- **AND** they represent 10% of total tests

### Requirement: Routing Architecture
The application SHALL use a centralized routing configuration with go_router.

#### Scenario: Single router definition
- **WHEN** defining application routes
- **THEN** all routes are consolidated in `lib/src/core/routing/app_router.dart`
- **AND** there are NO separate router files per feature
- **AND** route configuration is initialized at application startup

