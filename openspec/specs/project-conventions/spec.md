# project-conventions Specification

## Purpose
TBD - created by archiving change update-design-principles-ui-ux. Update Purpose after archive.
## Requirements
### Requirement: Design Philosophy

The application SHALL adhere to a design philosophy of **Clarity, Focus, and Insight**, maintaining a minimalist aesthetic for core functionality while introducing clean, data-driven visualizations where appropriate.

#### Scenario: Minimalist list view
- **WHEN** a developer implements a media list view
- **THEN** the interface SHALL prioritize content visibility with minimal chrome and clear hierarchy

#### Scenario: Data visualization clarity
- **WHEN** analytics or insights are presented
- **THEN** visualizations SHALL be simple, easy to understand, and not obscure the underlying data

#### Scenario: Focus on primary tasks
- **WHEN** designing any screen
- **THEN** the primary user action SHALL be immediately obvious and accessible

### Requirement: Color Palette

The application SHALL use a consistent, well-defined color palette that supports both light and dark themes and maintains accessibility standards (WCAG 2.1 AA minimum).

#### Scenario: Primary color definition
- **WHEN** implementing themed components
- **THEN** primary colors SHALL be derived from Material 3 ColorScheme with indigo as the seed color
- **AND** primary colors SHALL be used for main actions, active states, and brand elements

#### Scenario: Secondary accent colors
- **WHEN** implementing analytics or charts
- **THEN** a secondary accent color SHALL be defined to distinguish data visualizations from primary UI elements
- **AND** the accent color SHALL maintain sufficient contrast in both light and dark themes

#### Scenario: Semantic color usage
- **WHEN** displaying status or feedback
- **THEN** semantic colors SHALL be used consistently:
  - Success states: Green tones from Material 3 palette
  - Error states: Red tones from Material 3 palette
  - Warning states: Orange/amber tones from Material 3 palette
  - Info states: Blue tones from Material 3 palette

#### Scenario: Dark theme support
- **WHEN** the user enables dark theme
- **THEN** all colors SHALL automatically adapt using Material 3 dark theme ColorScheme
- **AND** color contrast SHALL meet WCAG 2.1 AA standards for all text and interactive elements

### Requirement: Typography

The application SHALL use a clean, legible typography system based on Material 3 type scale with consistent font families, sizes, and weights.

#### Scenario: Font family selection
- **WHEN** rendering text content
- **THEN** the default sans-serif font SHALL be used as specified by Material 3 guidelines
- **AND** system fonts SHALL be leveraged for optimal performance and native feel

#### Scenario: Type scale hierarchy
- **WHEN** implementing UI components
- **THEN** text SHALL follow Material 3 type scale:
  - Display Large/Medium/Small for hero content
  - Headline Large/Medium/Small for section headers
  - Title Large/Medium/Small for card titles and list headers
  - Body Large/Medium/Small for content text
  - Label Large/Medium/Small for buttons and labels

#### Scenario: Font weight usage
- **WHEN** emphasizing content
- **THEN** font weights SHALL be used consistently:
  - Regular (400) for body text
  - Medium (500) for emphasized text and labels
  - Bold (700) for headlines and important information
- **AND** avoid using more than three different weights in a single view

#### Scenario: Text accessibility
- **WHEN** displaying any text
- **THEN** minimum font size SHALL be 12sp for non-critical text
- **AND** body text SHALL be at least 14sp
- **AND** line height SHALL be 1.4-1.6x the font size for optimal readability

### Requirement: Responsive and Adaptive Design

The application SHALL implement responsive layouts that adapt to different screen sizes and orientations, following Material 3 and Flutter's responsive design guidelines.

#### Scenario: iOS phone adaptation
- **WHEN** running on iPhone (all sizes)
- **THEN** layouts SHALL use compact width breakpoints
- **AND** navigation SHALL use bottom navigation bar or tab bar patterns
- **AND** content SHALL be optimized for single-column layouts

#### Scenario: iOS tablet adaptation
- **WHEN** running on iPad
- **THEN** layouts SHALL use expanded width breakpoints for larger screens
- **AND** navigation MAY use split-view or sidebar patterns
- **AND** content SHALL leverage multi-column layouts where appropriate

#### Scenario: Android phone adaptation
- **WHEN** running on Android phones
- **THEN** layouts SHALL follow Material 3 compact window size class guidelines
- **AND** navigation SHALL use bottom navigation or navigation drawer patterns
- **AND** the interface SHALL respect system navigation (gesture or button-based)

#### Scenario: Android tablet adaptation
- **WHEN** running on Android tablets
- **THEN** layouts SHALL follow Material 3 medium/expanded window size class guidelines
- **AND** navigation SHALL use navigation rail or persistent navigation drawer
- **AND** content SHALL adapt to wider viewports with appropriate gutters and max-widths

#### Scenario: macOS desktop adaptation
- **WHEN** running on macOS
- **THEN** layouts SHALL use expanded window size classes
- **AND** navigation SHALL use sidebar patterns with hierarchical content
- **AND** the interface SHALL support mouse/trackpad interactions (hover states, right-click menus)
- **AND** windows SHALL be resizable with minimum size constraints

#### Scenario: Orientation changes
- **WHEN** device orientation changes
- **THEN** layouts SHALL gracefully reflow content without losing user context
- **AND** state SHALL be preserved across orientation changes
- **AND** media content SHALL adapt to maximize viewport usage

#### Scenario: Breakpoint consistency
- **WHEN** implementing responsive layouts
- **THEN** breakpoints SHALL align with Material 3 window size classes:
  - Compact: width < 600dp
  - Medium: 600dp ≤ width < 840dp
  - Expanded: width ≥ 840dp

### Requirement: Platform-Specific Guidelines

The application SHALL respect platform-specific design conventions while maintaining cross-platform consistency in core functionality.

#### Scenario: iOS design patterns
- **WHEN** running on iOS
- **THEN** the app SHALL follow iOS Human Interface Guidelines for:
  - Navigation patterns (back button behavior, swipe gestures)
  - Modal presentations and sheets
  - Action sheets and alerts
  - Safe area insets

#### Scenario: Android design patterns
- **WHEN** running on Android
- **THEN** the app SHALL follow Material 3 guidelines for:
  - Navigation patterns (back button behavior, drawer patterns)
  - Bottom sheets and dialogs
  - Floating action buttons
  - Snackbars for transient feedback

#### Scenario: macOS design patterns
- **WHEN** running on macOS
- **THEN** the app SHALL follow macOS design conventions for:
  - Window management (title bar, traffic lights)
  - Menu bar integration
  - Keyboard shortcuts
  - Context menus

### Requirement: Accessibility

The application SHALL be accessible to users with disabilities, meeting WCAG 2.1 Level AA standards at minimum.

#### Scenario: Screen reader support
- **WHEN** a user enables screen reader (VoiceOver, TalkBack)
- **THEN** all interactive elements SHALL have meaningful semantic labels
- **AND** navigation order SHALL be logical and predictable
- **AND** dynamic content changes SHALL be announced appropriately

#### Scenario: Color contrast
- **WHEN** displaying text or interactive elements
- **THEN** color contrast ratios SHALL meet WCAG 2.1 AA standards:
  - Normal text: minimum 4.5:1
  - Large text (18pt+): minimum 3:1
  - Interactive elements: minimum 3:1

#### Scenario: Touch target sizes
- **WHEN** implementing interactive elements
- **THEN** minimum touch target size SHALL be 44x44 points on iOS and 48x48dp on Android
- **AND** adequate spacing SHALL separate adjacent interactive elements

#### Scenario: Text scaling
- **WHEN** user adjusts system text size
- **THEN** the application SHALL respect accessibility text scaling
- **AND** layouts SHALL remain functional up to 200% text scaling
- **AND** text SHALL not be truncated or overlapped at larger sizes

### Requirement: Material 3 Compliance

The application SHALL use Material 3 (Material You) design system components and patterns as defined in https://m3.material.io.

#### Scenario: Material 3 components
- **WHEN** building UI elements
- **THEN** Material 3 widgets SHALL be used preferentially (e.g., NavigationBar, NavigationRail, Card with filled/elevated variants)
- **AND** custom components SHALL visually align with Material 3 design tokens

#### Scenario: Dynamic color support
- **WHEN** running on Android 12+ devices
- **THEN** the app SHALL support Material You dynamic colors when appropriate
- **AND** users SHALL be able to opt into system-generated color schemes

#### Scenario: Motion and transitions
- **WHEN** implementing animations and transitions
- **THEN** motion SHALL follow Material 3 motion guidelines:
  - Use emphasize easing for important transitions
  - Keep animation durations appropriate (200-400ms for most transitions)
  - Provide motion reduction options for accessibility

