# app

A new Flutter project.

## MVCS Architecture

- MODEL – Holds the state of the application and provides an API to access/filter/manipulate that data. Its concern is data encapsulation and management. It contains logic to structure, validate or compare different pieces of data that we call Domain Logic.
- VIEW – Views are all the Widgets and Pages within the Flutter Application. These views may contain a “view controller” themselves, but that is still considered part of the view application tier.
- CONTROLLER – The controller layer is represented by various Commands which contain the Application Logic of the app. Commands are used to complete any significant action within your app.
- SERVICES – Services fetch data from the outside world, and return it to the app. Commands call on services and inject the results into the model. Services do not touch the model directly.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
