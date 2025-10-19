# Implementation Tasks

## 1. Remove Legacy State Management
- [x] 1.1 Remove `lib/assets/models/asset_model.dart` (Provider model)
- [x] 1.2 Remove `lib/assets/models/sessions_model.dart` (Provider model)
- [x] 1.3 Remove `lib/settings/models/settings_model.dart` (Provider model)

## 2. Remove Legacy Command Pattern
- [x] 2.1 Remove `lib/shared/commands/abstract_command.dart` (base command)
- [x] 2.2 Remove all asset commands (2 files in `lib/assets/commands/assets/`)
- [x] 2.3 Remove all session commands (7 files in `lib/assets/commands/sessions/`)
- [x] 2.4 Remove all settings commands (5 files in `lib/settings/commands/`)

## 3. Remove Legacy Data Models
- [x] 3.1 Remove `lib/assets/models/asset.dart` (replaced by domain entity and data model)
- [x] 3.2 Remove `lib/assets/models/session.dart` (replaced by domain entity and data model)
- [x] 3.3 Remove `lib/settings/models/settings.dart` (replaced by domain entity and data model)

## 4. Remove Legacy Routers
- [x] 4.1 Remove `lib/assets/router.dart` (consolidated into `app_router.dart`)
- [x] 4.2 Remove `lib/settings/router.dart` (consolidated into `app_router.dart`)
- [x] 4.3 Remove `lib/shared/router.dart` (consolidated into `app_router.dart`)

## 5. Remove Legacy Services
- [x] 5.1 Remove `lib/assets/services/assets_service.dart` (functionality moved to data sources)
- [x] 5.2 Remove `lib/shared/services/subscriptions_service.dart` (unused service)

## 6. Remove Legacy Shared Infrastructure
- [x] 6.1 Remove `lib/shared/models/datastore.dart` (replaced by `lib/src/core/database/datastore.dart`)
- [x] 6.2 Remove `lib/shared/app.dart` (replaced by `lib/src/presentation/app.dart`)
- [x] 6.3 Remove `lib/shared/constants.dart` (replaced by `lib/src/core/constants/app_constants.dart`)
- [x] 6.4 Remove `lib/shared/utils.dart` (replaced by `lib/src/core/utils/app_utils.dart`)
- [x] 6.5 Remove `lib/shared/theme.dart` (replaced by `lib/src/presentation/shared/theme.dart`)
- [x] 6.6 Remove `lib/shared/views/loading_view.dart` (replaced by `lib/src/presentation/shared/views/loading_view.dart`)

## 7. Remove Legacy Views
- [x] 7.1 Remove `lib/assets/views/years_view.dart` (stub exists at `lib/src/presentation/features/media/views/years_view.dart`)
- [x] 7.2 Remove `lib/assets/views/months_view.dart` (stub exists at new location)
- [x] 7.3 Remove `lib/assets/views/sort_swipe_view.dart` (stub exists at new location)
- [x] 7.4 Remove `lib/assets/views/sort_summary_view.dart` (stub exists at new location)
- [x] 7.5 Remove `lib/assets/views/my_viewer.dart` (to be reimplemented)
- [x] 7.6 Remove `lib/settings/views/list.dart` (stub exists at new location)
- [x] 7.7 Remove `lib/settings/views/authorize_view.dart` (stub exists at new location)

## 8. Remove Legacy Widgets
- [x] 8.1 Remove asset widgets (11 files in `lib/assets/widgets/`)
- [x] 8.2 Remove settings widgets (5 files in `lib/settings/widgets/`)
- [x] 8.3 Remove asset overlay (`lib/assets/overlays/deletion_in_progress.dart`)

## 9. Remove Empty Directories
- [x] 9.1 Remove `lib/assets/` directory and all subdirectories
- [x] 9.2 Remove `lib/settings/` directory and all subdirectories
- [x] 9.3 Remove `lib/shared/` directory and all subdirectories

## 10. Clean Up Imports
- [x] 10.1 Run `flutter analyze` to find broken imports
- [x] 10.2 Fix any remaining references to legacy paths
- [x] 10.3 Remove unused imports flagged by analyzer

## 11. Validation
- [x] 11.1 Run `flutter analyze` and verify zero errors
- [x] 11.2 Run `dart run build_runner build` to ensure ObjectBox generation still works
- [x] 11.3 Verify app compiles successfully
- [x] 11.4 Spot check that no old imports remain in active code
