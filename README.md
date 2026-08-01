# 🐾 Pokémon Application (`my_poke_app`)

แอปพลิเคชันค้นหาและแสดงข้อมูลโปเกมอน พัฒนาด้วย **Flutter** ตามสถาปัตยกรรม **Layer-First Architecture** เชื่อมต่อข้อมูลจริงจาก **[PokéAPI](https://pokeapi.co/)** ตกแต่งสไตล์ทันสมัยด้วย **`shadcn_ui`** และจัดการการนำทางด้วย **`go_router`**

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)

```text
my_poke_app/
├── android/
├── ios/
├── web/
├── pubspec.yaml                 # Dependencies: shadcn_ui, go_router, http, lucide_icons
└── lib/
    ├── app/                     # [1] App Configuration & Setup ส่วนกลาง
    │   └── config/
    │       ├── app_routes.dart  # จัดการ Routing ทั้งหมดด้วย go_router (ShellRoute, Path Params)
    │       └── app_theme.dart   # ตั้งค่า Theme ของ shadcn_ui (Zinc Light/Dark Mode)
    │
    ├── models/                  # [2] Data Classes / Deserialization
    │   └── pokemon.dart         # Data models: PokemonListItem & PokemonDetail
    │
    ├── services/                # [3] Network & Business Logic Services
    │   ├── auth_service.dart    # Mock Login / Register Authentication API
    │   └── poke_api_service.dart# HTTP Client ยิงขอข้อมูลจาก PokéAPI (List & Detail)
    │
    ├── views/                   # [4] UI Layer (Screens & Layouts)
    │   ├── main_tree.dart       # Shell Container สำคัญสำหรับผูก Bottom Navigation Bar
    │   │
    │   └── pages/               # รวมหน้าจอทั้งหมด แยกตามหมวดหมู่
    │       ├── auth/
    │       │   ├── login_page.dart     # หน้า Login (ใช้ ShadCard, ShadInput, ShadButton)
    │       │   └── register_page.dart  # หน้า Register (ใช้ ShadCard, ShadInput, ShadButton)
    │       │
    │       ├── home/
    │       │   ├── home_page.dart      # หน้าแสดง Grid รายชื่อโปเกมอน จาก PokéAPI
    │       │   └── detail_page.dart    # หน้าแสดงรายละเอียด, Type (ShadBadge) และ Stats
    │       │
    │       ├── search/
    │       │   └── search_page.dart    # หน้าค้นหาโปเกมอน (Search Bar)
    │       │
    │       ├── favorites/
    │       │   └── favorites_page.dart # หน้าโปเกมอนโปรด (Coming Soon Placeholder)
    │       │
    │       ├── profile/
    │       │   └── profile_page.dart   # หน้าโปรไฟล์เทรนเนอร์ (Profile Placeholder)
    │       │
    │       └── settings/
    │           └── settings_page.dart  # หน้าการตั้งค่าแอปพลิเคชัน
    │
    └── main.dart                # [5] Entry Point หลักของแอป (เรียกใช้ ShadApp.router)
```

---

## ⚡ คุณสมบัติหลัก (Features)

1. **Layer-First Architecture**: จัดโครงสร้างโค้ดแยกตาม Layer ชัดเจน (`app/config`, `models`, `services`, `views`).
2. **PokéAPI Integration**: ดึงข้อมูลรายชื่อและรายละเอียดโปเกมอนแบบเรียลไทม์จาก [PokéAPI](https://pokeapi.co/).
3. **Shadcn UI Design System**: ใช้ UI Components จาก `shadcn_ui` เช่น `ShadApp`, `ShadThemeData` (`ShadZincColorScheme`), `ShadCard`, `ShadInput`, `ShadButton`, และ `ShadBadge`.
4. **Declarative Navigation (`go_router`)**:
   - `/login`, `/register`: หน้ายืนยันตัวตน.
   - `ShellRoute` (`MainTree`): ควบคุม Bottom Navigation Bar สำหรับแท็บหลัก (`/home`, `/search`, `/favorites`, `/profile`, `/settings`).
   - `/home/detail/:id`: Dynamic sub-route สำหรับแสดงรายละเอียดโปเกมอนตาม ID.

---

## 🚀 ขั้นตอนการติดตั้งและเริ่มใช้งาน

1. **ดาวน์โหลดการพึ่งพา (Dependencies)**:
   ```bash
   flutter pub get
   ```

2. **ตรวจสอบโค้ด (Static Analysis)**:
   ```bash
   flutter analyze
   ```

3. **รันแอปพลิเคชัน**:
   ```bash
   flutter run
   ```
