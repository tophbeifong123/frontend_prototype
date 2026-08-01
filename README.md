# Frontend Prototype 🚀

A high-performance, modern **Flutter application prototype** built following industry **Best Practices** and **Clean Feature-First Architecture**.

![Flutter](https://img.shields.io/badge/Flutter-3.44.6-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.6-00599C?style=for-the-badge&logo=flutter&logoColor=white)

---

## 📐 Architecture & Project Structure

This project adopts a **Feature-First Architecture** combined with **Clean Architecture** principles to promote modularity, scalability, and testability.

```
lib/
├── app/                        # Global App Configuration
│   ├── app.dart                # MaterialApp.router configuration
│   ├── router/                 # GoRouter declarations & deep linking
│   │   └── app_router.dart
│   └── theme/                  # Design System (Colors, Typography, Themes)
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── app_typography.dart
├── core/                       # Shared Utilities & Base Classes
│   ├── constants/              # App static constants
│   ├── errors/                 # Exception & Failure handlers
│   └── widgets/                # Reusable UI Components (GlassCard, CustomButton, StatusBadge)
├── features/                   # Self-contained domain modules
│   ├── dashboard/              # Dashboard Feature
│   │   ├── data/               # Repositories & Data Sources
│   │   ├── domain/             # Entities & Models
│   │   └── presentation/       # Riverpod Controllers & UI Screens
│   ├── details/                # Detail Views
│   └── settings/               # System Settings & Preferences
└── main.dart                   # Entry point wrapped in ProviderScope
```

---

## ✨ Key Technical Highlights

1. **State Management**: Scalable reactive state powered by **Flutter Riverpod** (`FutureProvider`, `Provider`).
2. **Routing**: Declarative navigation & dynamic route params using **GoRouter**.
3. **Design System**: Modern Dark Mode UI featuring **Glassmorphic components**, custom gradients, and **Google Fonts** (`Outfit` & `Inter`).
4. **Clean Error Handling**: Strongly-typed `Failure` domain hierarchy.
5. **Code Quality**: Strict static analysis configured via `analysis_options.yaml`.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- [Dart SDK](https://dart.dev/get-dart)

### Installation & Execution

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/tophbeifong123/frontend_prototype.git
   cd frontend_prototype
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Code Analysis**:
   ```bash
   flutter analyze
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 🛠️ Built With
- **Flutter**: Cross-platform UI toolkit.
- **Flutter Riverpod**: Compile-safe state management.
- **GoRouter**: Declarative routing system.
- **Google Fonts**: Custom typography engine.
