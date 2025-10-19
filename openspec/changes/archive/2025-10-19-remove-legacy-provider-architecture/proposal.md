# Remove Legacy Provider Architecture

## Why

After completing the refactoring to Clean Architecture with BLoC/Cubit (change `refactor-architecture-to-clean-mvvm`), the codebase contains obsolete files from the previous Provider + ChangeNotifier + Command pattern implementation. These legacy files create:
- Technical debt and maintenance burden
- Confusion for developers about which code is active
- Increased codebase size and complexity
- Risk of accidentally using deprecated patterns

## What Changes

**BREAKING**: This change removes all legacy architecture files that have been replaced by the new Clean Architecture implementation:

- Remove legacy Provider models (`lib/assets/models/asset_model.dart`, `lib/assets/models/sessions_model.dart`, `lib/settings/models/settings_model.dart`)
- Remove legacy Command pattern files (17 command files under `lib/assets/commands/` and `lib/settings/commands/`)
- Remove legacy data models that duplicate new entities (`lib/assets/models/asset.dart`, `lib/assets/models/session.dart`, `lib/settings/models/settings.dart`)
- Remove legacy routers (`lib/assets/router.dart`, `lib/settings/router.dart`, `lib/shared/router.dart`)
- Remove legacy service files (`lib/assets/services/assets_service.dart`, `lib/shared/services/subscriptions_service.dart`)
- Remove legacy shared utilities now in new locations (`lib/shared/models/datastore.dart`, `lib/shared/app.dart`, `lib/shared/commands/abstract_command.dart`)
- Remove legacy views/widgets that have stub replacements in new structure (32 view/widget files)
- Clean up unused imports across the codebase
- Update any remaining references to point to new architecture

## Impact

- **Affected specs**: `core-architecture`, `media-management`, `settings-management`
- **Affected code**: 60+ files to be removed, numerous import statements to be cleaned
- **Breaking changes**: Any code still referencing old paths will break (but all production code has been migrated)
- **Benefits**: Cleaner codebase, reduced confusion, easier maintenance
- **Risk**: Low - all functionality has been replicated in new architecture
