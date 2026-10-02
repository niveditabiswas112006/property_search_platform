# Property Search Platform 🏡

A modern, highly-responsive Flutter application designed for seamless property discovery. This platform allows users to browse handpicked homes, explore new properties, check out nearby hotspots, and view detailed information including 3D property tours.

---

## 🎨 UI/UX Design
- **Modern & Clean Aesthetic**: Emphasizes a minimal and professional look with ample whitespace, clean typography, and rounded corners to make property images stand out.
- **Micro-interactions & Polish**: Uses subtle animations, smooth page transitions, and interactive elements (like the Heart/Favorite buttons) to keep the user engaged.
- **Intuitive Navigation**: Features a bottom navigation bar for quick access to Home, Search, Saved properties, and Profile screens.
- **Categorized Discovery**: Includes horizontal scrollable chips (All, Rent, Buy, For Sale, New) to quickly filter properties based on user intent.

## 📱 Theming and Responsiveness
- **Cross-Platform Consistency**: Designed to provide a native feel on both Android and iOS devices using Flutter's Material Design principles.
- **Adaptive Layouts**: Uses responsive UI components (like `Expanded`, `Flexible`, `LayoutBuilder`, and `MediaQuery`) to ensure the application scales beautifully across different screen sizes—from compact mobile phones to larger tablets.
- **Consistent Design Language**: Implements centralized theming for colors, text styles, and button shapes to maintain visual harmony throughout the application.

## 🛠 Dart Fundamentals and Package Ecosystem
- **Strongly Typed Models**: Uses strict Dart classes (e.g., `Property` model) with required parameters and null safety to define property data, amenities, and floor plans.
- **State Management**: Implements clean state lifecycles to handle UI updates effectively when switching between tabs or interacting with properties.
- **Third-Party Integrations**:
  - `cupertino_icons`: Used for standard, high-quality iOS-style icons across the app.
  - `panorama_viewer`: Integrated to provide immersive 360° / 3D virtual tours of the properties, giving users a real-life feel of the homes.
  - `url_launcher`: Used to handle external links, open maps for locations, or initiate calls to builders/agents.

## 🏗 Build Configurations and Deployment Readiness
- **Release Optimization**: The app is configured for production builds (`flutter build apk --release`), taking advantage of Flutter's tree-shaking (removing unused code/icons) and ahead-of-time (AOT) compilation for maximum performance.
- **Network Permissions**: Explicitly configured `AndroidManifest.xml` with `<uses-permission android:name="android.permission.INTERNET"/>` to ensure smooth loading of high-quality network images in release mode.
- **GitHub Actions / Versioning**: Maintains a strict versioning format (`1.0.1`) and leverages GitHub Releases for distributing compiled APKs seamlessly to users.

## 🧩 Frontend Architecture & Imports
The frontend is logically separated into distinct, maintainable directories:
- **`lib/models/`**: Contains data structures (`property_model.dart`) that shape how real estate data is consumed.
- **`lib/screens/`**: Houses the individual UI pages (`login_screen.dart`, `login_sections.dart`, home screens, etc.).
- **`lib/main.dart`**: The entry point of the application setting up the `MaterialApp` and routing.

**Core Imports Used:**
- `package:flutter/material.dart` - Core UI library for structural and interactive widgets.
- `package:panorama_viewer/panorama_viewer.dart` - For rendering the 3D property tours.
- `package:url_launcher/url_launcher.dart` - For external intents.

---

### How to Run Locally

1. Ensure you have [Flutter installed](https://docs.flutter.dev/get-started/install).
2. Clone the repository: `git clone https://github.com/niveditabiswas112006/property_search_platform.git`
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```
