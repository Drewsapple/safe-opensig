# Safe Verify Mobile App

Second factor verification for Safe accounts.

## Table of Contents
- [About](#about)
- [Tech Stack](#tech-stack)
  - [Flutter Version](#flutter-version)
  - [State Management](#state-management)
  - [Storage](#storage)
  - [Navigation](#navigation)
- [Folder Structure](#folder-structure)
- [Getting Started](#getting-started)
  - [Installation](#installation)
- [Contributing](#contributing)
  - [Code Style](#code-style)
  - [Branching Strategy](#branching-strategy)

## About

Safe Verify is a mobile application designed to provide second factor verification for Safe transactions. It enhances the security of your Safe transaction flow by adding an additional layer of verification/simulation.

## Tech Stack

### Flutter Version

This project uses Flutter version `3.32.4` managed by FVM (Flutter Version Management). FVM ensures that all developers are using the same Flutter version, preventing compatibility issues.

To install and use FVM please refer to their [docs](https://fvm.app/documentation/getting-started)

### State Management

We use [Riverpod](https://pub.dev/packages/flutter_riverpod) for state management
Riverpod provides a robust and scalable way to manage state with compile-time safety and easy testing.

### Storage

[Hive](https://pub.dev/packages/hive_ce_flutter) is used for local storage
Hive is a lightweight and fast key-value database written in Dart, perfect for storing user preferences and account data locally.

### Navigation

[GoRouter](https://pub.dev/packages/go_router) handles navigation:
GoRouter provides a declarative approach to routing and navigation with deep linking support.

## Folder Structure
```
lib/
├── core/              
│   ├── router/        # Application routing
│   ├── storage/       # Storage related classes
│   └── theme/         # App themes and styling
├── features/          
│   ├── account_management/
│   └── onboarding/
├── hive/              # Hive related models and adapters
├── shared/            # Shared utilities and widgets
└── main.dart          
```

## Getting Started

### Installation
1. Install dependencies:
   ```bash
   fvm flutter pub get
   ```

2. Run the app:
   ```bash
   fvm flutter run
   ```

## Contributing

We welcome contributions to the Safe Verify App! Please follow these guidelines when contributing.

### Code Style

- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code before committing
- Run `flutter analyze` to check for any analysis issues

### Branching Strategy

- `main` - Production-ready code
- `develop` - Development branch, all pull requests should be made to this branch
- `feature/*` - Feature branches, branched from `develop`
- `fix/*`
- `refactor/*`
- `hotfix/*` - Hotfix branches for critical production issues