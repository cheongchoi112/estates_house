# Estates House

Real Estate Platform

## Getting Started

Here are a few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help with Flutter development, view the [online documentation](https://docs.flutter.dev/), which includes tutorials, samples, guidance on mobile development, and a full API reference.

## Add Firebase to Your Flutter App

### Prerequisites

- [Node.js](https://nodejs.org/en/download/)
- [npm](https://www.npmjs.com/get-npm)

### Installation - Firebase

Follow the [official Firebase setup guide](https://firebase.google.com/docs/flutter/setup?platform=web) for detailed instructions.

#### Step 1: Install the Required Command Line Tools

If you haven't already, install the Firebase CLI:

```sh
npm install -g firebase-tools
```

Log into Firebase using your Google account by running:

```sh
firebase login
```

Install the FlutterFire CLI by running:

```sh
dart pub global activate flutterfire_cli
```

**Note:** If you encounter a `command not found` error for `flutterfire`, ensure that Dart's `pub` cache binary directory is added to your system's `PATH`.

- **macOS/Linux:**
  ```sh
  export PATH="$PATH":"$HOME/.pub-cache/bin"
  ```
- **Windows:** Add `%USERPROFILE%\AppData\Local\Pub\Cache\bin` to your `PATH` environment variable.

#### Step 2: Configure Your Apps to Use Firebase

Use the FlutterFire CLI to configure your Flutter apps to connect to Firebase:

```sh
flutterfire.bat configure
```

This workflow will:

- Guide you through selecting your Firebase project.
- Generate the `firebase_options.dart` file with your Firebase configuration.
- Update your Flutter project to initialize Firebase with the generated options.

### Additional Commands

To upgrade your Flutter dependencies to the latest major versions, run:

```sh
flutter pub upgrade --major-versions
```

### Firebase Hosting Deployment

```sh
flutter build web --release

firebase deploy --only hosting:house-platform-78131

firebase deploy --only hosting:homemvp
```

## Project Structure

This project follows the principles of Clean Architecture for a modular, testable, and maintainable codebase. Here’s an overview of each layer:

### Presentation Layer

- **Purpose:** Contains the UI components and screens of the application.
- **Files:**
  - `LandingPage`: Main landing page where users can search for properties.
  - `LoginPage`: Login page for user authentication.
  - `UserDashboard`: User dashboard for managing properties.
  - `Widgets`: Reusable UI components like `PropertyList` and `PropertyCard`.

### Domain Layer

- **Purpose:** Contains the core business logic and entities.
- **Files:**
  - `Entities`: Data models like `Property`.
  - `Services`: Interfaces for business operations, e.g., `IPropertyService` and `IUserSessionService`.

### Data Layer

- **Purpose:** Handles data access and service implementations.
- **Files:**
  - `Services`: Concrete implementations of domain service interfaces, e.g., `PropertyService` and `UserSessionService`.

### Core Layer

- **Purpose:** Contains core utilities and configurations.
- **Files:**
  - `Network`: Network-related utilities like `FirebaseApiClient`.
  - `Dependency Injection`: Setup for dependency injection using `GetIt`, e.g., `setup_locator`.
