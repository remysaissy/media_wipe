# Media Management Specification

## ADDED Requirements

### Requirement: Media Assets State Management
The application SHALL manage media assets (photos and videos) state using a BLoC in the presentation layer.

#### Scenario: MediaBloc handles asset state
- **WHEN** managing media assets state
- **THEN** a `MediaBloc` is implemented in `lib/src/presentation/features/media/blocs/media/`
- **AND** the BLoC handles events for loading, refreshing, and filtering assets
- **AND** the BLoC emits states representing loading, loaded, error, and empty conditions

#### Scenario: Asset loading triggered by event
- **WHEN** assets need to be loaded
- **THEN** a `LoadMediaEvent` is dispatched to MediaBloc
- **AND** the BLoC calls appropriate use cases to fetch assets
- **AND** the BLoC emits a new state with loaded assets

#### Scenario: Asset refresh triggered by event
- **WHEN** assets need to be refreshed from device library
- **THEN** a `RefreshMediaEvent` is dispatched to MediaBloc
- **AND** the BLoC calls RefreshPhotosUseCase to sync with device library
- **AND** the BLoC emits updated state with refreshed assets

### Requirement: Review Session State Management
The application SHALL manage review sessions using a SessionCubit in the presentation layer.

#### Scenario: SessionCubit handles session state
- **WHEN** managing review sessions
- **THEN** a `SessionCubit` is implemented in `lib/src/presentation/features/media/blocs/session/`
- **AND** the Cubit provides methods for starting, finishing, and managing sessions
- **AND** the Cubit emits states representing no session, active session, and session summary

#### Scenario: Session lifecycle methods
- **WHEN** user interacts with review sessions
- **THEN** Cubit provides `startSession()` to begin a new review
- **AND** Cubit provides `keepAsset()` and `dropAsset()` to mark decisions
- **AND** Cubit provides `undoLastOperation()` to revert last decision
- **AND** Cubit provides `finishSession()` to complete review

### Requirement: Media Domain Entities
The application SHALL define pure Dart entity classes for media domain concepts.

#### Scenario: Asset entity represents a media item
- **WHEN** working with media assets in business logic
- **THEN** an `Asset` entity class exists in `lib/src/domain/entities/`
- **AND** the entity contains assetId, creationDate, and other domain properties
- **AND** the entity has NO ObjectBox annotations

#### Scenario: Session entity represents a review session
- **WHEN** working with review sessions in business logic
- **THEN** a `Session` entity class exists in `lib/src/domain/entities/`
- **AND** the entity contains session metadata, keep/drop lists, and timestamps
- **AND** the entity has NO ObjectBox annotations

### Requirement: Media Use Cases
The application SHALL encapsulate media business logic in use case classes in the domain layer.

#### Scenario: RefreshPhotosUseCase syncs device library
- **WHEN** synchronizing media from device
- **THEN** a `RefreshPhotosUseCase` exists in `lib/src/domain/usecases/media/`
- **AND** the use case calls AssetRepository to fetch device photos
- **AND** the use case returns a list of Asset entities

#### Scenario: DeleteAssetsUseCase removes media
- **WHEN** deleting selected assets
- **THEN** a `DeleteAssetsUseCase` exists in `lib/src/domain/usecases/media/`
- **AND** the use case accepts a list of asset IDs and dry-run flag
- **AND** the use case calls AssetRepository to delete assets

#### Scenario: Session management use cases
- **WHEN** managing review sessions
- **THEN** use cases exist for StartSession, FinishSession, DropAssetInSession, KeepAssetInSession, UndoLastOperationInSession
- **AND** each use case is in `lib/src/domain/usecases/media/sessions/`
- **AND** use cases interact with SessionRepository

### Requirement: Asset Repository Interface
The application SHALL define an AssetRepository interface in the domain layer for asset data operations.

#### Scenario: Repository interface defines asset operations
- **WHEN** accessing asset data
- **THEN** an abstract `AssetRepository` interface exists in `lib/src/domain/repositories/`
- **AND** the interface defines methods: getAssets(), addAssets(), updateAssets(), deleteAssets(), getAsset()
- **AND** methods work with domain Asset entities, not data models

#### Scenario: Repository implementation in data layer
- **WHEN** implementing asset data access
- **THEN** `AssetRepositoryImpl` exists in `lib/src/data/repositories/`
- **AND** implementation uses AssetLocalDataSource to access ObjectBox
- **AND** implementation maps between AssetEntity (data model) and Asset (domain entity)

### Requirement: Session Repository Interface
The application SHALL define a SessionRepository interface in the domain layer for session data operations.

#### Scenario: Repository interface defines session operations
- **WHEN** accessing session data
- **THEN** an abstract `SessionRepository` interface exists in `lib/src/domain/repositories/`
- **AND** the interface defines methods: createSession(), updateSession(), deleteSession(), getActiveSession(), getAllSessions()
- **AND** methods work with domain Session entities

#### Scenario: Repository implementation in data layer
- **WHEN** implementing session data access
- **THEN** `SessionRepositoryImpl` exists in `lib/src/data/repositories/`
- **AND** implementation uses SessionLocalDataSource to access ObjectBox
- **AND** implementation maps between SessionEntity (data model) and Session (domain entity)

### Requirement: Asset Local Data Source
The application SHALL provide a data source for local asset storage operations using ObjectBox.

#### Scenario: Data source encapsulates ObjectBox operations
- **WHEN** accessing ObjectBox for assets
- **THEN** an `AssetLocalDataSource` class exists in `lib/src/data/datasources/`
- **AND** the data source wraps ObjectBox Box<AssetEntity> operations
- **AND** the data source provides methods matching repository needs
- **AND** the data source works with AssetEntity data models

#### Scenario: Asset entity model with ObjectBox annotations
- **WHEN** defining asset database schema
- **THEN** an `AssetEntity` class exists in `lib/src/data/local/models/`
- **AND** the class has ObjectBox @Entity annotation
- **AND** the class defines id, assetId, creationDate fields with appropriate annotations

### Requirement: Media Views with BLoC Integration
The application SHALL implement media views using BlocProvider and BlocBuilder to connect with state management.

#### Scenario: YearsView displays assets by year
- **WHEN** displaying years view
- **THEN** `YearsView` widget exists in `lib/src/presentation/features/media/views/`
- **AND** the view wraps content with BlocProvider<MediaBloc>
- **AND** the view uses BlocBuilder to react to MediaBloc state changes
- **AND** the view dispatches LoadMediaEvent on initialization

#### Scenario: MonthsView displays assets by month
- **WHEN** displaying months view for a year
- **THEN** `MonthsView` widget exists in `lib/src/presentation/features/media/views/`
- **AND** the view uses BlocBuilder<MediaBloc> to access assets
- **AND** the view filters assets by selected year

#### Scenario: SortSwipeView provides review interface
- **WHEN** reviewing assets in swipe mode
- **THEN** `SortSwipeView` exists in `lib/src/presentation/features/media/views/`
- **AND** the view uses BlocBuilder<SessionCubit> to track session state
- **AND** the view dispatches keep/drop events on swipe gestures

#### Scenario: SortSummaryView displays review results
- **WHEN** viewing review session summary
- **THEN** `SortSummaryView` exists in `lib/src/presentation/features/media/views/`
- **AND** the view uses BlocBuilder<SessionCubit> to display session results
- **AND** the view provides options to refine or commit decisions

### Requirement: Media Widgets
The application SHALL provide reusable media widgets in the presentation layer.

#### Scenario: Widgets are framework-aware UI components
- **WHEN** creating reusable media UI components
- **THEN** widgets are placed in `lib/src/presentation/features/media/widgets/`
- **AND** widgets include MediaViewer, Month, Year, DeleteButton, RefineButton, SortPhotosControls, etc.
- **AND** widgets receive data through constructor parameters
- **AND** widgets emit user actions through callbacks

#### Scenario: Widgets do not contain business logic
- **WHEN** implementing widgets
- **THEN** widgets do NOT call use cases directly
- **AND** widgets do NOT access repositories directly
- **AND** widgets MAY read BLoC state via context.read or BlocBuilder

### Requirement: Asset Service Migration
The application SHALL migrate the existing AssetsService to a data source following repository pattern.

#### Scenario: Photo permissions handled by use case
- **WHEN** requesting photo library permissions
- **THEN** an `AuthorizePhotosUseCase` exists in `lib/src/domain/usecases/media/`
- **AND** the use case calls methods on AssetLocalDataSource or a PermissionService
- **AND** permission logic is NOT in the presentation layer

#### Scenario: Device library fetching in data source
- **WHEN** fetching assets from device library
- **THEN** `AssetLocalDataSource` provides `listAssetsFromDevice(year: int)` method
- **AND** the method uses PhotoManager package to query device library
- **AND** the method returns AssetEntity data models
