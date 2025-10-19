# Scripts Directory

Utility scripts for development, testing, and deployment.

## Available Scripts

Currently, this directory is reserved for future utility scripts. The project previously used ObjectBox which required native library setup scripts, but has been migrated to Isar which handles native libraries automatically through the `isar_flutter_libs` package.

## Test Execution

Run the full test suite:

```bash
flutter test
```

Run specific test suites:

```bash
# Data source tests
flutter test test/data/datasources/

# Integration tests
flutter test test/integration/

# Unit tests only
flutter test test/domain/ test/presentation/ test/data/repositories/ test/data/mappers/
```

## CI/CD Integration

Tests are automatically run via GitHub Actions. See `.github/workflows/test.yml` for the configuration.

The CI pipeline includes:
- Code analysis and formatting checks
- Unit tests (without Isar native dependencies)
- Full integration tests with Isar (on Linux and macOS)

## Adding New Scripts

When adding new scripts to this directory:

1. Use descriptive names (e.g., `setup_*.sh`, `deploy_*.sh`)
2. Add shebang line: `#!/bin/bash`
3. Set exit on error: `set -e`
4. Make executable: `chmod +x scripts/your_script.sh`
5. Document in this README

## References

- [Project Test Documentation](../test/README.md)
- [CI/CD Setup Guide](../.github/CI_SETUP.md)
- [Isar Documentation](https://isar.dev/)
