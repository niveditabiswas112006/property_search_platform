# Property Search Platform 🏡

A modern, responsive, and visually appealing Flutter application designed for searching, viewing, and exploring properties, inspired by platforms like Housing.com.

## 📱 Screenshots

> **Note to Developer:** You can easily add your screenshots here! Just click the "Edit" (pencil) button on this README in GitHub, and drag-and-drop your screenshot images right into the editor. GitHub will automatically upload them and create the correct links for you!
<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/34be551b-f9ea-4dca-b944-986075363f8a" />
<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/7ad1bc87-8815-4404-b392-05aa08cc0ce6" />
<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/e755acdf-9d05-417a-952c-17ff85a91172" />
<img width="717" height="1600" alt="image" src="https://github.com/user-attachments/assets/ad57c258-b51f-4003-b9b9-275ccb35420f" />

---

## 🎨 UI/UX Design, Theming & Responsiveness

The application is built with a strong emphasis on user experience and modern UI paradigms:
* **Theming**: Utilizes `ThemeData` with a primary blue swatch and a clean `Roboto` typography for a professional look.
* **Responsiveness**: Designed to adapt across different screen sizes. Custom scroll behaviors (`MaterialScrollBehavior`) are implemented to ensure smooth scrolling across touch, mouse, and stylus inputs, making it seamless on both mobile and web/desktop environments.
* **Component Architecture**: The UI is broken down into modular components (e.g., `login_sections.dart`, `login_screen.dart`) to maintain clean code and reusability.

## 🛠 Dart Fundamentals & Package Ecosystem

The project leverages core Dart fundamentals alongside a robust package ecosystem:
* **Object-Oriented Models**: Uses strongly typed models (like `Property` in `property_model.dart`) to structure complex data like prices, RERA verification status, floor plans, and amenities.
* **`panorama_viewer`**: Integrated to provide immersive 360-degree / 3D tours of properties.
* **`url_launcher`**: Used for redirecting users to external resources or maps.
* **`cupertino_icons`**: Provides high-quality, iOS-styled iconography alongside standard Material design icons.

## 🚀 Build Configurations & Deployment Readiness

The application is configured for production-grade deployment:
* **Permissions**: Configured with Android `INTERNET` permissions (`<uses-permission android:name="android.permission.INTERNET"/>`) in `AndroidManifest.xml` to ensure network images load flawlessly in release mode.
* **Release Optimization**: Uses `--release` build flags to enable Tree-shaking (removing unused fonts/icons) and AOT (Ahead-of-Time) compilation for maximum performance.
* **Version Control & CI/CD**: Tracked via Git, with build artifacts strictly ignored via `.gitignore` to keep the repository lightweight and ready for GitHub Actions or direct GitHub Releases.

## 🧩 Frontend Architecture & Imports

The frontend is strictly separated into modular directories:
* **Core Imports**: 
  * `package:flutter/material.dart` for the foundational Material widgets.
  * `package:flutter/gestures.dart` for advanced pointer and scroll control.
* **Screens & Sections**: Logic and UI are separated into `login_screen.dart` and modular components within `login_sections.dart`.
* **State Management & Routing**: Utilizes Flutter's native routing (`initialRoute: '/'`) for navigation and standard stateful/stateless widget composition.

---

### Getting Started Locally

1. Ensure you have [Flutter installed](https://docs.flutter.dev/get-started/install) and running.
2. Clone the repository and run `flutter pub get` to fetch the packages.
3. Run the app using `flutter run` on your connected device or emulator.
