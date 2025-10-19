# Project Context

## Purpose
An intelligent application to review, sort and remove media on a device.
It automatically read media libraries and build year/month organized lists of media to review.
It keeps track of media reviewed and those still waiting for review.
During a review, it provides all useful information at a glance and let the user swipe to decide to keep or drop.
At the end of a review session, it lets the user double check its choices, refining it if necessary.

Designed for ease of use and privacy, it supports all official EU languages, features a clean interface, fully runs locally and includes analytics to track shopping habits and recommend new products.

It comes as a Flutter application that runs on iOS (iPhone and iPad), Android (phones and tablets) and MacOS.
It is designed to be a high-quality, performant application using the latest technologies. The application is self-contained and does not rely on a remote backend; all data is stored locally on the device.

## Tech Stack

### Technologies

* **Framework:** Flutter
* **UI Toolkit:** Material 3 and Flutter guidelines
* **Local Storage:** Isar
* **State Management:** BLoC
* **Other aspects**: Follows the recommendations on https://docs.flutter.dev/platform-integration/ios/apple-frameworks
* **Target OS Version**: The application must target the oldest possible OS version that supports all required APIs for its features, conventions, and tech stack. If a specific feature requires a newer API, the minimum deployment target will be set to that OS version, but not higher, to maximize device compatibility.

### Platform Support

The application is designed to run on the following platforms:

*   **iOS:** iPhone and iPad
*   **Android:** Phones and Tablets
*   **macOS:** Desktop

Platform-specific code should be minimized. When necessary, it should be placed in `platform` specific directories and abstracted away from the shared business logic.

## Project Conventions

### Design Principles & UI/UX

#### Design Philosophy

The application adheres to a design philosophy of **Clarity, Focus, and Insight**:

*   **Clarity**: The interface prioritizes content visibility with minimal chrome and clear hierarchy. Every screen makes the primary user action immediately obvious and accessible.
*   **Focus**: The design remains minimalist for core functionality, avoiding unnecessary visual elements that distract from the user's task.
*   **Insight**: When presenting analytics or insights, visualizations are simple, easy to understand, and never obscure the underlying data.

#### Color Palette

The application uses a consistent, well-defined color palette that supports both light and dark themes and maintains accessibility standards (WCAG 2.1 AA minimum).

*   **Primary Colors**: Derived from Material 3 ColorScheme with **indigo** as the seed color. Used for main actions, active states, and brand elements.
*   **Secondary Accent Colors**: A secondary accent color distinguishes data visualizations and analytics from primary UI elements. This color maintains sufficient contrast in both light and dark themes.
*   **Semantic Colors**: Consistent usage across the application:
    *   **Success**: Green tones from Material 3 palette
    *   **Error**: Red tones from Material 3 palette
    *   **Warning**: Orange/amber tones from Material 3 palette
    *   **Info**: Blue tones from Material 3 palette
*   **Dark Theme**: All colors automatically adapt using Material 3 dark theme ColorScheme. Color contrast meets WCAG 2.1 AA standards for all text and interactive elements.
*   **Accessibility**: All color combinations meet minimum contrast ratios:
    *   Normal text: 4.5:1
    *   Large text (18pt+): 3:1
    *   Interactive elements: 3:1

#### Typography

The application uses a clean, legible typography system based on Material 3 type scale:

*   **Font Family**: Default sans-serif font as specified by Material 3 guidelines, leveraging system fonts for optimal performance and native feel.
*   **Type Scale**: Text follows Material 3 type scale hierarchy:
    *   **Display** Large/Medium/Small: Hero content and major headings
    *   **Headline** Large/Medium/Small: Section headers
    *   **Title** Large/Medium/Small: Card titles and list headers
    *   **Body** Large/Medium/Small: Content text
    *   **Label** Large/Medium/Small: Buttons and labels
*   **Font Weights**: Consistent usage across the application:
    *   **Regular (400)**: Body text
    *   **Medium (500)**: Emphasized text and labels
    *   **Bold (700)**: Headlines and important information
    *   Avoid using more than three different weights in a single view
*   **Accessibility**:
    *   Minimum font size: 12sp for non-critical text
    *   Body text: at least 14sp
    *   Line height: 1.4-1.6x font size for optimal readability
    *   Text scales gracefully up to 200% for accessibility

#### Responsive and Adaptive Design

The application implements responsive layouts that adapt to different screen sizes and orientations, following Material 3 Guidelines (https://m3.material.io) and Flutter's Responsive and Adaptive guidelines (https://docs.flutter.dev/ui/adaptive-responsive).

##### Breakpoints

Layouts align with Material 3 window size classes:

*   **Compact**: width < 600dp (phones in portrait)
*   **Medium**: 600dp ≤ width < 840dp (tablets in portrait, phones in landscape)
*   **Expanded**: width ≥ 840dp (tablets in landscape, desktops)

##### Platform-Specific Adaptations

**iOS (iPhone and iPad)**:
*   **iPhone**: Compact width breakpoints with bottom navigation bar or tab bar patterns. Single-column layouts optimized for one-handed use.
*   **iPad**: Expanded width breakpoints with split-view or sidebar patterns. Multi-column layouts leveraging the larger screen.
*   **Platform Conventions**: Follows iOS Human Interface Guidelines for navigation (back button behavior, swipe gestures), modal presentations, action sheets, and safe area insets.

**Android (Phones and Tablets)**:
*   **Phones**: Material 3 compact window size class with bottom navigation or navigation drawer. Interface respects system navigation (gesture or button-based).
*   **Tablets**: Material 3 medium/expanded window size classes with navigation rail or persistent drawer. Content adapts with appropriate gutters and max-widths.
*   **Platform Conventions**: Follows Material 3 guidelines for navigation patterns, bottom sheets, dialogs, floating action buttons, and snackbars.

**macOS (Desktop)**:
*   **Layouts**: Expanded window size classes with sidebar patterns and hierarchical content organization.
*   **Interactions**: Full support for mouse/trackpad (hover states, right-click menus). Windows are resizable with minimum size constraints.
*   **Platform Conventions**: Follows macOS design conventions for window management, menu bar integration, keyboard shortcuts, and context menus.

##### Orientation Handling

*   Layouts gracefully reflow content without losing user context when orientation changes
*   State is preserved across orientation changes
*   Media content adapts to maximize viewport usage

#### Accessibility

The application is accessible to users with disabilities, meeting WCAG 2.1 Level AA standards at minimum:

*   **Screen Readers**: All interactive elements have meaningful semantic labels. Navigation order is logical and predictable. Dynamic content changes are announced appropriately.
*   **Touch Targets**: Minimum touch target size of 44x44 points on iOS and 48x48dp on Android, with adequate spacing between adjacent interactive elements.
*   **Text Scaling**: The application respects accessibility text scaling up to 200%. Layouts remain functional and text is not truncated or overlapped at larger sizes.
*   **Color Independence**: Information is never conveyed by color alone. Icons, labels, or patterns supplement color-coded information.

#### Material 3 Compliance

The application uses Material 3 (Material You) design system components and patterns:

*   **Components**: Material 3 widgets are used preferentially (e.g., NavigationBar, NavigationRail, Card with filled/elevated variants). Custom components visually align with Material 3 design tokens.
*   **Dynamic Color**: On Android 12+ devices, the app supports Material You dynamic colors, allowing users to opt into system-generated color schemes.
*   **Motion**: Animations and transitions follow Material 3 motion guidelines, using emphasize easing for important transitions. Animation durations are appropriate (200-400ms for most transitions), with motion reduction options for accessibility.

### Code Style

* **Formatting:** We use the standard Dart formatter (`dart format .`).
* **Linting:** We use `flutter_lints` with additional rules defined in `analysis_options.yaml`. All code must be free of linter warnings.
* **Naming Conventions:**
    *   Classes: `PascalCase`
    *   Files: `snake_case.dart`
    *   Variables and functions: `camelCase`
    *   Constants: `kCamelCase`
* **Imports:** Organize imports using the official guidelines (Dart, then Package, then Project).
* **Commenting**: Code must include clear and concise comments adhering to best practices. This includes documenting the purpose of public APIs and components, explaining complex logic, and clarifying architectural decisions to ensure readability and maintainability.

### Architecture Patterns

We will follow the **MVVM (Model-View-ViewModel)** architectural pattern to ensure a clean separation of concerns. This promotes a modular, testable, and maintainable codebase.

*   **Model:** Represents the data and business logic of the application. These are the entities from the Domain Layer and data models from the Data Layer.
*   **View:** Represents the UI of the application. In Flutter, these are the Widgets. The View is responsible for displaying the data from the ViewModel and capturing user input. It should be as "dumb" as possible, containing no business logic.
*   **ViewModel:** Acts as a bridge between the Model and the View. It exposes data from the Model to the View and provides commands for the View to execute. The ViewModel is responsible for the presentation logic. In our application, the **BLoC/Cubit will act as the ViewModel**.

The overall structure is also influenced by Clean Architecture principles, dividing the app into three main layers:

*   **Presentation Layer (View + ViewModel):** Contains the UI (Widgets) and the BLoCs/Cubits that manage the state and presentation logic.
*   **Domain Layer:** Contains the core business logic, use cases, and entity definitions. This layer is completely independent of the UI and data sources.
*   **Data Layer:** Contains the implementation of the repositories and data sources. It is responsible for fetching data from local (Isar) or remote sources.

#### Repository Pattern

The Data Layer must use the **Repository Pattern**. Repositories are responsible for abstracting the data sources. They provide a clean API for the Domain Layer to access data, without needing to know where the data comes from (e.g., a local database or a remote API).

##### Data Persistence

All application data is stored locally using Isar.

*   **Schema Definition:** Isar entities are defined in the `lib/src/data/local/models` directory.
*   **Database Initialization:** Isar is initialized at application startup.
*   **Data Access:** Data access should be encapsulated within `DataSource` classes in the data layer. Repositories will use these data sources to interact with the database.

#### State Management

We use the **BLoC (Business Logic Component)** pattern for state management. It helps in separating the presentation layer from the business logic, making the app more structured and testable.

*   **Cubit vs. BLoC:**
    *   Use `Cubit` for simple states with no complex business logic. A `Cubit` is a simpler version of a `Bloc` that has no concept of events and relies on methods to emit new states.
    *   Use `Bloc` for more complex states that require traceability of events, or when you need to handle complex business logic.

*   **Library:** We use the `flutter_bloc` package.

*   **Structure:**
    *   BLoCs/Cubits should be placed in `lib/src/presentation/blocs` or `lib/src/presentation/cubits`.
    *   Each feature should have its own BLoC/Cubit.
    *   States and events should be defined in separate files within the BLoC/Cubit's directory (e.g., `my_feature_bloc/my_feature_state.dart`, `my_feature_bloc/my_feature_event.dart`).

*   **UI Interaction:**
    *   Use `BlocProvider` to provide BLoCs/Cubits to the widget tree.
    *   Use `BlocBuilder`, `BlocListener`, or `BlocConsumer` to react to state changes in the UI.
    *   Dispatch events to the BLoC from the UI to trigger state changes.

#### Dependency Management

*   Dependencies are managed in the `pubspec.yaml` file.
*   Use specific versions for all dependencies to ensure reproducible builds.
*   Before adding a new dependency, evaluate its impact on the project (maintenance, performance, etc.).

#### Dependency Injection

We will use **Dependency Injection (DI)** to provide dependencies to different parts of the application. This helps in decoupling the code and makes it easier to test.

*   **Library:** We will use the `get_it` package for service location and dependency injection.
*   **Setup:** All dependencies should be registered in a central location, typically in a `lib/src/core/di/injection_container.dart` file. This setup should be called at the application startup.
*   **Usage:** Dependencies should be resolved as late as possible, typically at the point where they are needed. For example, a BLoC might receive a repository as a constructor parameter, and `get_it` will be used to provide this instance when the BLoC is created.

#### Game Development

For any game development within this application, it is mandatory to use the **Flutter Casual Games Toolkit**. This toolkit provides a set of best practices, templates, and utilities to accelerate the development of casual games.

*   **Adherence:** All game-related features must be built following the patterns and recommendations of the toolkit.
*   **Components:** Leverage the pre-built components and integrations provided by the toolkit for features like audio, state management, and monetization.
*   **Architecture:** The game's architecture should be based on the templates provided by the toolkit.

### Testing Strategy

We aim for a comprehensive test suite to ensure code quality and application stability. The testing strategy follows the 70/20/10 ratio:

*   **70% Unit Tests:**
    *   Focus on testing individual functions, methods, and classes.
    *   Located in the `test` directory, mirroring the `lib` directory structure.
    *   Examples: Testing business logic in BLoCs/ViewModels, utility functions, and repository methods (with mocked data sources).

*   **20% Integration Tests:**
    *   Focus on testing the interaction between different parts of the application.
    *   Located in the `test/integration` directory.
    *   Examples: Testing the flow from the UI to the database, testing a feature that involves multiple classes. This can include widget tests that test a screen or a flow of screens.

*   **10% End-to-End (E2E) Tests:**
    *   Focus on testing the application as a whole, from the user's perspective.
    *   Located in the `integration_test` directory.
    *   Uses `flutter_driver` or `patrol` to drive the application and simulate user interactions.
    *   Examples: Testing user login flow, creating a new item and verifying it's displayed correctly.

#### Continuous Integration (CI) with GitHub Actions
To maintain code quality and automate our testing process, we use **GitHub Actions**.

* **Automated Workflows**: Workflows defined in the `.github/workflows/` directory automatically run on every push and pull request. These workflows are responsible for:
    * **Linting**: Running `SwiftLint` to enforce code style and conventions.
    * **Testing**: Executing the full suite of unit and integration tests using `xcodebuild`.
    * **Building**: Compiling the application to ensure it builds correctly for all target platforms (iOS, macOS).
* **Status Checks**: A pull request cannot be merged until all CI checks have passed successfully, ensuring that no broken code is introduced into the `main` branch.

#### Local Workflow Execution
To catch issues before pushing code, developers are encouraged to run CI workflows locally using `act`. This tool allows you to execute your GitHub Actions workflows in a local Docker environment, providing fast feedback and reducing the likelihood of a failed build in the remote repository.

### Git Workflow
We follow the **GitHub Flow** branching model, which is a simple yet powerful strategy centered around pull requests. This ensures that the main branch is always stable and deployable.
* `main` Branch: This branch contains the production-ready code. Direct pushes to main are strictly forbidden. Merges only happen after a pull request from a feature branch is reviewed and approved.
* **Feature Branches**: All new work, including features, bug fixes, and experiments, must be done on a dedicated feature branch created from `main`.
* **Naming Convention**: Branches should be named descriptively, using a prefix like `feature/`, `fix/`, or `chore/`. For example: `feature/add-item-parsing` or `fix/crash-on-launch`.
* **Pull Requests (PRs)**: When a feature is complete, a pull request is opened to merge the feature branch into `main`. Every PR must:
    * Have a clear title and a descriptive summary of the changes.
    * Be reviewed and approved by at least one other team member.
    * **Pass all automated status checks** configured with GitHub Actions (see Testing Strategy).
* **Commit Conventions**: We adhere to the **Conventional Commits** specification. This creates an explicit and easily readable commit history.
* **Format**: `<type>[optional scope]: <description>`
* **Example**: `feat: implement shopping list analytics view` or `fix(parser): correctly handle duplicate items`.

#### Release Management
Creating a new release is an automated process managed by a dedicated GitHub Action. This ensures consistency and reduces manual error.
* **Manual Trigger**: The release workflow is triggered manually from the GitHub Actions tab using a `workflow_dispatch` event. The person triggering the release will be prompted to specify the version bump type: **major**, **minor**, or **patch**, according to **Semantic Versioning (SemVer)** rules.
* **Automated Process**: Once triggered, the workflow executes the following steps on the `main` branch:
    * **Version Bump**: The action calculates the next version number based on the latest Git tag and the specified bump type (e.g., if the latest tag is `v1.2.5` and `patch` is selected, the new version will be `v1.2.6`).
* **Generate Release Notes**: It automatically generates release notes by compiling all Conventional Commit messages since the last release tag. Commits like `feat:` will be under a "Features" heading, and `fix:` will be under "Bug Fixes".
* **Create Git Tag**: A new, annotated Git tag with the new version number (e.g., `v1.2.6`) is created and pushed to the `main` branch.
* **Create GitHub Release**: Finally, it creates a new **GitHub Release** corresponding to the new tag. The auto-generated release notes are used as the release description, providing a clear and detailed changelog for users.

## Domain Context
[Add domain-specific knowledge that AI assistants need to understand]

## Important Constraints
[List any technical, business, or regulatory constraints]

## External Dependencies
[Document key external services, APIs, or systems]
