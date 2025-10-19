# settings-management Specification

## Purpose
TBD - created by archiving change refactor-architecture-to-clean-mvvm. Update Purpose after archive.
## Requirements
### Requirement: Settings State Management
The application SHALL manage user settings state using a Cubit in the presentation layer.

#### Scenario: SettingsCubit handles settings state
- **WHEN** managing application settings
- **THEN** a `SettingsCubit` is implemented in `lib/src/presentation/features/settings/blocs/settings/`
- **AND** the Cubit provides methods for loading, updating theme, updating debug flags, and onboarding state
- **AND** the Cubit emits states representing loaded settings

#### Scenario: Settings loaded at startup
- **WHEN** application initializes
- **THEN** SettingsCubit calls LoadSettingsUseCase to retrieve persisted settings
- **AND** Cubit emits state with loaded settings
- **AND** if no settings exist, Cubit creates default settings

#### Scenario: Theme update method
- **WHEN** user changes theme preference
- **THEN** Cubit provides `updateTheme(ThemeMode mode)` method
- **AND** method calls UpdateSettingsUseCase with updated theme
- **AND** method emits new state with updated theme

#### Scenario: Debug flag update method
- **WHEN** user toggles debug dry removal mode
- **THEN** Cubit provides `updateDebugFlag(bool isDryRun)` method
- **AND** method calls UpdateSettingsUseCase
- **AND** method emits new state with updated flag

#### Scenario: Onboarding completion method
- **WHEN** user completes onboarding
- **THEN** Cubit provides `completeOnboarding()` method
- **AND** method updates settings to mark onboarding as complete
- **AND** method emits new state

### Requirement: Settings Domain Entity
The application SHALL define a pure Dart Settings entity class in the domain layer.

#### Scenario: Settings entity represents user preferences
- **WHEN** working with settings in business logic
- **THEN** a `Settings` entity class exists in `lib/src/domain/entities/`
- **AND** the entity contains theme, debugDryRun, onboardingDone properties
- **AND** the entity has NO ObjectBox annotations
- **AND** the entity has NO Flutter framework dependencies

### Requirement: Settings Use Cases
The application SHALL encapsulate settings business logic in use case classes in the domain layer.

#### Scenario: LoadSettingsUseCase retrieves settings
- **WHEN** loading user settings
- **THEN** a `LoadSettingsUseCase` exists in `lib/src/domain/usecases/settings/`
- **AND** the use case calls SettingsRepository to fetch settings
- **AND** the use case returns a Settings entity

#### Scenario: UpdateSettingsUseCase persists changes
- **WHEN** updating user settings
- **THEN** an `UpdateSettingsUseCase` exists in `lib/src/domain/usecases/settings/`
- **AND** the use case accepts a Settings entity
- **AND** the use case calls SettingsRepository to persist changes

#### Scenario: RequestInAppReviewUseCase triggers review prompt
- **WHEN** requesting in-app review
- **THEN** a `RequestInAppReviewUseCase` exists in `lib/src/domain/usecases/settings/`
- **AND** the use case interacts with a ReviewService or platform channel
- **AND** the use case encapsulates review trigger logic

### Requirement: Settings Repository Interface
The application SHALL define a SettingsRepository interface in the domain layer for settings data operations.

#### Scenario: Repository interface defines settings operations
- **WHEN** accessing settings data
- **THEN** an abstract `SettingsRepository` interface exists in `lib/src/domain/repositories/`
- **AND** the interface defines methods: getSettings(), updateSettings()
- **AND** methods work with domain Settings entity

#### Scenario: Repository implementation in data layer
- **WHEN** implementing settings data access
- **THEN** `SettingsRepositoryImpl` exists in `lib/src/data/repositories/`
- **AND** implementation uses SettingsLocalDataSource to access ObjectBox
- **AND** implementation maps between SettingsEntity (data model) and Settings (domain entity)

### Requirement: Settings Local Data Source
The application SHALL provide a data source for local settings storage operations using ObjectBox.

#### Scenario: Data source encapsulates ObjectBox operations
- **WHEN** accessing ObjectBox for settings
- **THEN** a `SettingsLocalDataSource` class exists in `lib/src/data/datasources/`
- **AND** the data source wraps ObjectBox Box<SettingsEntity> operations
- **AND** the data source provides get() and update() methods
- **AND** the data source works with SettingsEntity data models

#### Scenario: Settings entity model with ObjectBox annotations
- **WHEN** defining settings database schema
- **THEN** a `SettingsEntity` class exists in `lib/src/data/local/models/`
- **AND** the class has ObjectBox @Entity annotation
- **AND** the class defines id, theme, debugDryRun, onboardingDone fields

### Requirement: Settings Views with BLoC Integration
The application SHALL implement settings views using BlocProvider and BlocBuilder to connect with state management.

#### Scenario: Settings ListView displays configuration options
- **WHEN** displaying settings screen
- **THEN** settings list view exists in `lib/src/presentation/features/settings/views/`
- **AND** the view uses BlocProvider<SettingsCubit>
- **AND** the view uses BlocBuilder to react to SettingsCubit state
- **AND** the view displays theme selector, debug options, and other settings

#### Scenario: AuthorizeView handles photo permissions
- **WHEN** user needs to grant photo permissions
- **THEN** `AuthorizeView` exists in `lib/src/presentation/features/settings/views/`
- **AND** the view triggers AuthorizePhotosUseCase through a BLoC or directly
- **AND** the view displays permission status and action button

### Requirement: Settings Widgets
The application SHALL provide reusable settings widgets in the presentation layer.

#### Scenario: Widgets are framework-aware UI components
- **WHEN** creating reusable settings UI components
- **THEN** widgets are placed in `lib/src/presentation/features/settings/widgets/`
- **AND** widgets include ThemeDropdown, AuthorizePhotos, DebugDryRemoval, RateApp, Link
- **AND** widgets receive data and callbacks through constructor parameters

#### Scenario: ThemeDropdown updates theme through Cubit
- **WHEN** user selects a theme
- **THEN** `ThemeDropdown` widget calls SettingsCubit.updateTheme()
- **AND** widget listens to SettingsCubit state to display current theme

#### Scenario: AuthorizePhotos widget triggers permission request
- **WHEN** user requests photo permission
- **THEN** `AuthorizePhotos` widget triggers appropriate use case or BLoC event
- **AND** widget displays current permission status

### Requirement: Settings Command Migration
The application SHALL migrate existing settings commands to use cases and Cubit methods.

#### Scenario: UpdateThemeCommand becomes Cubit method
- **WHEN** updating theme
- **THEN** `UpdateThemeCommand` is eliminated
- **AND** functionality is implemented as `SettingsCubit.updateTheme()` method
- **AND** method calls UpdateSettingsUseCase

#### Scenario: UpdateDebugFlagCommand becomes Cubit method
- **WHEN** toggling debug flag
- **THEN** `UpdateDebugFlagCommand` is eliminated
- **AND** functionality is implemented as `SettingsCubit.updateDebugFlag()` method

#### Scenario: UpdateOnboardingCommand becomes Cubit method
- **WHEN** completing onboarding
- **THEN** `UpdateOnboardingCommand` is eliminated
- **AND** functionality is implemented as `SettingsCubit.completeOnboarding()` method

#### Scenario: AuthorizePhotosCommand becomes use case
- **WHEN** authorizing photo access
- **THEN** `AuthorizePhotosCommand` is eliminated
- **AND** functionality is implemented as `AuthorizePhotosUseCase` in domain layer

#### Scenario: RequestInAppReviewCommand becomes use case
- **WHEN** requesting in-app review
- **THEN** `RequestInAppReviewCommand` is eliminated
- **AND** functionality is implemented as `RequestInAppReviewUseCase` in domain layer

