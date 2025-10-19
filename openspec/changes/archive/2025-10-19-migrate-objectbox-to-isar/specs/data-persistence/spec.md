# Data Persistence Capability

## ADDED Requirements

### Requirement: Isar Database Initialization
The application SHALL use Isar as the local database solution for all data persistence needs.

#### Scenario: Database initialization on app startup
- **WHEN** the application starts for the first time
- **THEN** an Isar database instance is created in the application support directory
- **AND** all collection schemas (Asset, Session, Settings) are registered
- **AND** the database is ready for read and write operations

#### Scenario: Singleton database instance
- **WHEN** multiple components request the database instance
- **THEN** the same Isar instance is returned to all requestors
- **AND** no duplicate database connections are created

#### Scenario: Platform-specific storage location
- **WHEN** initializing the database on macOS
- **THEN** the database is stored in the application group directory for data sharing
- **AND** the path includes the application group identifier `io.weavly.apps.media_wipe.8D96AS3ZME`

### Requirement: Entity Collections with Isar Annotations
The application SHALL define all entity models using Isar collection annotations and schemas.

#### Scenario: Asset entity collection
- **WHEN** defining the Asset entity
- **THEN** it uses the `@collection` annotation
- **AND** it has an auto-incrementing `Id` field
- **AND** it stores `assetId` as a String
- **AND** it stores `creationDate` as DateTime
- **AND** transient fields use `@ignore` annotation

#### Scenario: Session entity with relationships
- **WHEN** defining the Session entity
- **THEN** it uses the `@collection` annotation
- **AND** it has an auto-incrementing `Id` field
- **AND** it uses `IsarLinks<Asset>` for many-to-many `assetsToDrop` relationship
- **AND** it uses `IsarLinks<Asset>` for many-to-many `refineAssetsToDrop` relationship
- **AND** it uses `IsarLink<Asset>` for one-to-one `assetInReview` relationship
- **AND** it stores `sessionYear` and `sessionMonth` as integers

#### Scenario: Settings entity with enums
- **WHEN** defining the Settings entity
- **THEN** it uses the `@collection` annotation
- **AND** it has an auto-incrementing `Id` field
- **AND** it persists ThemeMode enum using custom getters and setters
- **AND** it stores boolean flags for `hasPhotosAccess`, `hasInAppReview`, and `debugDryRemoval`

### Requirement: CRUD Operations with Isar API
The application SHALL implement all data access operations using Isar's query and transaction APIs.

#### Scenario: Read operations
- **WHEN** reading all entities of a type
- **THEN** the datasource uses `isar.collection.where().findAll()`
- **AND** the operation returns all records from the collection

#### Scenario: Read by ID
- **WHEN** retrieving an entity by its ID
- **THEN** the datasource uses `isar.collection.get(id)`
- **AND** the operation returns the entity if found, null otherwise

#### Scenario: Write operations
- **WHEN** inserting or updating entities
- **THEN** the datasource wraps operations in `isar.writeTxn()`
- **AND** uses `isar.collection.put(entity)` for single inserts/updates
- **AND** uses `isar.collection.putAll(entities)` for batch inserts/updates
- **AND** the transaction commits atomically

#### Scenario: Delete operations
- **WHEN** deleting entities
- **THEN** the datasource wraps operations in `isar.writeTxn()`
- **AND** uses `isar.collection.delete(id)` for single deletes
- **AND** uses `isar.collection.deleteAll(ids)` for batch deletes
- **AND** the transaction commits atomically

### Requirement: Query Filtering with Isar Query Builder
The application SHALL use Isar's query builder API for all filtered queries.

#### Scenario: Query by date range
- **WHEN** querying assets by year
- **THEN** the datasource uses `isar.assets.filter().creationDateBetween(start, end).findAll()`
- **AND** the start date is the first moment of the year
- **AND** the end date is the first moment of the next year
- **AND** all assets with creation dates in that range are returned

#### Scenario: Query by year and month
- **WHEN** querying assets by specific year and month
- **THEN** the datasource uses `isar.assets.filter().creationDateBetween(start, end).findAll()`
- **AND** the start date is the first moment of the month
- **AND** the end date is the first moment of the next month
- **AND** all assets with creation dates in that range are returned

#### Scenario: Query by string field
- **WHEN** querying an asset by its assetId string
- **THEN** the datasource uses `isar.assets.filter().assetIdEqualTo(assetId).findFirst()`
- **AND** the first matching asset is returned, or null if not found

### Requirement: Relationship Management with Isar Links
The application SHALL manage entity relationships using Isar's link system.

#### Scenario: Adding entities to a many-to-many relationship
- **WHEN** adding assets to a session's `assetsToDrop` list
- **THEN** the datasource loads the session with its links
- **AND** adds asset references to the `IsarLinks` collection
- **AND** saves the link relationship within a write transaction
- **AND** the relationship is persisted in the database

#### Scenario: Reading relationship data
- **WHEN** accessing a session's related assets
- **THEN** the links are loaded using `session.assetsToDrop.load()`
- **AND** all related asset entities are available in the links collection
- **AND** the assets maintain their entity properties

#### Scenario: Removing entities from a relationship
- **WHEN** removing assets from a session's relationship
- **THEN** the datasource loads the session with its links
- **AND** removes asset references from the `IsarLinks` collection
- **AND** saves the updated relationship within a write transaction
- **AND** the asset entities themselves are not deleted, only the relationship

### Requirement: Code Generation for Isar Schemas
The application SHALL generate Isar schema code using the build_runner tool.

#### Scenario: Schema generation during development
- **WHEN** entity models are modified with Isar annotations
- **THEN** the developer runs `dart run build_runner build`
- **AND** Isar generator creates schema files with `.g.dart` extension
- **AND** the generated files include collection schemas and field definitions
- **AND** the generated files are checked into version control

#### Scenario: Generated code imports
- **WHEN** using Isar in the application
- **THEN** the code imports `package:isar/isar.dart`
- **AND** imports generated schema files
- **AND** does NOT import ObjectBox packages

### Requirement: Data Migration from ObjectBox to Isar
The application SHALL automatically migrate existing ObjectBox data to Isar on first launch after update.

#### Scenario: Detecting need for migration
- **WHEN** the application starts after updating from ObjectBox version
- **THEN** the app checks for the existence of ObjectBox database files
- **AND** checks if migration has already been completed
- **AND** determines whether migration is needed

#### Scenario: Successful data migration
- **WHEN** migration is needed and initiated
- **THEN** the app initializes both ObjectBox (read-only) and Isar (write)
- **AND** reads all AssetEntity records from ObjectBox
- **AND** transforms and writes them to Isar Asset collection
- **AND** reads all SessionEntity records with relationships from ObjectBox
- **AND** transforms and writes them to Isar Session collection, preserving relationships
- **AND** reads all SettingsEntity records from ObjectBox
- **AND** transforms and writes them to Isar Settings collection
- **AND** marks migration as complete in app preferences
- **AND** the app proceeds to normal operation with Isar

#### Scenario: Migration failure handling
- **WHEN** migration encounters an error
- **THEN** the app logs the error with detailed context
- **AND** rolls back any partial Isar data
- **AND** keeps ObjectBox data intact
- **AND** displays error message to user
- **AND** provides option to retry migration
- **AND** prevents app usage until migration succeeds

#### Scenario: Post-migration cleanup
- **WHEN** the app has successfully migrated and run for at least one app version
- **THEN** old ObjectBox database files MAY be deleted
- **AND** ObjectBox-related generated files are no longer present in the codebase
- **AND** only Isar database files exist in the application support directory

### Requirement: Testing with Isar In-Memory Database
The application SHALL use Isar's in-memory database instances for unit and integration tests.

#### Scenario: Test database setup
- **WHEN** setting up tests for data sources
- **THEN** test setup creates a temporary directory
- **AND** initializes an Isar instance with all schemas in that directory
- **AND** each test uses an isolated database instance
- **AND** the database is disposed after tests complete

#### Scenario: Test data isolation
- **WHEN** running multiple test cases
- **THEN** each test has its own database instance
- **AND** data from one test does NOT affect other tests
- **AND** tests can run in parallel without conflicts

### Requirement: Dependency Injection for Isar Instance
The application SHALL provide the Isar database instance through dependency injection using get_it.

#### Scenario: Registering Isar in dependency container
- **WHEN** the application initializes the dependency injection container
- **THEN** the Isar instance is registered as a singleton in `lib/src/core/di/injection_container.dart`
- **AND** all datasources are registered with the Isar instance as a dependency
- **AND** datasources receive the Isar instance through constructor injection

#### Scenario: Retrieving Isar from container
- **WHEN** a component needs database access
- **THEN** it retrieves the datasource from `getIt<DataSourceType>()`
- **AND** the datasource has access to the Isar instance
- **AND** no component directly accesses the Isar instance except datasources
