# 🐾 Pokémon Application (`my_poke_app`)

แอปพลิเคชันค้นหาและแสดงข้อมูลโปเกมอน พัฒนาด้วย **Flutter** ตามสถาปัตยกรรม **BLoC + Repository Pattern (Best Practice Architecture)** เชื่อมต่อข้อมูลจริงจาก **[PokéAPI](https://pokeapi.co/)** ตกแต่งด้วย **`shadcn_ui`** และจัดการการนำทางด้วย **`go_router`**

---

## 📁 โครงสร้างโปรเจกต์ (BLoC + Repository Architecture)

```text
my_poke_app/
├── android/
├── ios/
├── web/
├── pubspec.yaml                 # Dependencies: shadcn_ui, go_router, http, lucide_icons, flutter_bloc, equatable
└── lib/
    ├── blocs/                   # [1] BLoC / Cubit (State Management Layer)
    │   ├── auth/                # AuthBloc, AuthEvent, AuthState (จัดการ Authentication State)
    │   │   ├── auth_bloc.dart
    │   │   ├── auth_event.dart
    │   │   └── auth_state.dart
    │   └── pokemon/             # PokemonBloc, PokemonEvent, PokemonState (จัดการ โปเกมอน State)
    │       ├── pokemon_bloc.dart
    │       ├── pokemon_event.dart
    │       └── pokemon_state.dart
    │
    ├── repositories/            # [2] Repository Layer (Abstract Data Access)
    │   ├── auth_repository.dart    # จัดการ Business Logic & Auth Storage Session
    │   └── pokemon_repository.dart # จัดการ Business Logic & PokéAPI Caching
    │
    ├── services/                # [3] Low-Level Network & Storage Services
    │   ├── auth_api_service.dart   # Raw Auth REST API Calls
    │   ├── poke_api_service.dart   # Raw PokéAPI HTTP Client
    │   └── local_storage_service.dart # In-Memory / Persistent Session Storage
    │
    ├── models/                  # [4] Data Models & JSON Deserialization
    │   └── pokemon.dart         # PokemonListItem, PokemonDetail, PokemonStat
    │
    ├── views/                   # [5] UI Presentation Layer
    │   ├── main_tree.dart       # Shell Container สำหรับ Bottom Navigation Bar
    │   └── pages/               # รวมหน้าจอทั้งหมด แยกตามหมวดหมู่
    │       ├── auth/
    │       │   ├── login_page.dart     # หน้า Login (ใช้ BlocConsumer + Shadcn UI)
    │       │   └── register_page.dart  # หน้า Register (ใช้ BlocConsumer + Shadcn UI)
    │       │
    │       ├── home/
    │       │   ├── home_page.dart      # หน้าแสดง Grid รายชื่อโปเกมอน (ใช้ BlocBuilder)
    │       │   └── detail_page.dart    # หน้าแสดงรายละเอียด, Type (ShadBadge) และ Base Stats
    │       │
    │       ├── search/
    │       │   └── search_page.dart    # หน้าค้นหาโปเกมอน
    │       │
    │       ├── favorites/
    │       │   └── favorites_page.dart # หน้าโปเกมอนโปรด
    │       │
    │       ├── profile/
    │       │   └── profile_page.dart   # หน้าโปรไฟล์เทรนเนอร์ ( Sign Out ผ่าน AuthBloc)
    │       │
    │       └── settings/
    │           └── settings_page.dart  # หน้าการตั้งค่าแอปพลิเคชัน
    │
    ├── app/                     # [6] App Configuration & Setup ส่วนกลาง
    │   └── config/
    │       ├── app_routes.dart  # จัดการ Routing ทั้งหมดด้วย go_router (ShellRoute, Path Params)
    │       └── app_theme.dart   # ตั้งค่า Theme ของ shadcn_ui (Zinc Light/Dark Mode)
    │
    └── main.dart                # [7] Entry Point หลัก (หุ้มด้วย MultiRepositoryProvider & MultiBlocProvider)
```

---

## ⚡ จุดเด่นของสถาปัตยกรรมนี้ (Best Practice Highlights)

1. **Separation of Concerns (การแยกหน้าที่ชัดเจน)**:
   - **UI Layer (`views/`)**: มีหน้าที่วาดหน้าจอและส่ง Event ไปหา BLoC ผ่าน `context.read<Bloc>()`.
   - **BLoC Layer (`blocs/`)**: ควบคุม State ของแอป รับ Event แปลงเป็น State แล้วส่งกลับให้ UI วาดใหม่ผ่าน `BlocBuilder` / `BlocConsumer`.
   - **Repository Layer (`repositories/`)**: เป็นคนกลางรวบรวมข้อมูลจากหลายแหล่ง (API, Local Storage) ส่งให้ BLoC.
   - **Service Layer (`services/`)**: ติดต่อกับระบบภายนอกจริงๆ (HTTP Get/Post, Storage).

2. **Testability & Scalability**:
   - สามารถเขียน Unit Test ทดสอบ BLoC และ Repository แยกกันได้อย่างอิสระด้วย Mocktail/Mockito.

3. **Shadcn UI & Responsive Navigation**:
   - ใช้ธีม Zinc (`ShadZincColorScheme`) ร่วมกับ `ShadApp.router` และ `GoRouter` `ShellRoute`.

---

## 🚀 ขั้นตอนการติดตั้งและเริ่มใช้งาน

1. **ติดตั้ง Dependencies**:
   ```bash
   flutter pub get
   ```

2. **ตรวจสอบความถูกต้องของโค้ด**:
   ```bash
   flutter analyze
   ```

3. **รันแอปพลิเคชัน**:
   ```bash
   flutter run
   ```
