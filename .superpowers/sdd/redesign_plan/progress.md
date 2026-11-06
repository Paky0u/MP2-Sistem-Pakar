# Implementation Plan: Redesign UI/UX PC DOCTOR "Diagnostic Console"

Plan for executing UI/UX redesign natively.

## Pre-flight: Shared Interfaces Check
- All screens consume `AppColors`, `AppTheme`, `GlassCard`, `AppBackground` from Tasks 1-3.
- No interface conflicts found.

## Tasks
- [x] Task 1: Tema & Shell Aplikasi (`lib/theme/app_theme.dart`)
- [x] Task 2: Primitif Layout & Gerak (`lib/widgets/app_background.dart`, `glass_card.dart`, `gradient_button.dart`, `press_scale.dart`, `staggered_entrance.dart`, `lib/utils/app_route.dart`)
- [x] Task 3: Primitif Data & Animasi (`lib/widgets/animated_counter.dart`, `skeleton.dart`, `code_chip.dart`, `selection_ring.dart`, `radar_scan.dart`)
- [x] Task 4: Onboarding Screen (`lib/screens/onboarding_screen.dart`)
- [x] Task 5: Home Screen & Menu Card (`lib/screens/home_screen.dart`, `lib/widgets/menu_card.dart`)
- [x] Task 6: Diagnosis Screen (`lib/screens/diagnosis_screen.dart`)
- [x] Task 7: Hasil Diagnosis Screen & Kerusakan Card (`lib/screens/hasil_diagnosis_screen.dart`, `lib/widgets/kerusakan_card.dart`)
- [x] Task 8: Kamus Screen (`lib/screens/kamus_screen.dart`)
- [x] Task 9: Riwayat Screen (`lib/screens/riwayat_screen.dart`)
- [x] Task 10: Tentang Screen & Info Card (`lib/screens/tentang_screen.dart`, `lib/widgets/info_card.dart`)
- [x] Task 11: Regresi & Verifikasi Penuh (`test/inference_engine_test.dart` + Flutter test + Flutter analyze)

## Polish Round (UX)
- [x] Simpan hasil diagnosis ke riwayat otomatis (DI + tes)
- [x] Haptic feedback pada MenuCard/PressScale & pilihan gejala
- [x] Kontras tombol disabled (`GradientButton`)
- [x] Dialog animasi scanning radar sebelum hasil
- [x] Pencarian gejala di `DiagnosisScreen`
- [x] Onboarding hanya sekali (`shared_preferences` + `SplashGate`)
- [x] Perbaikan ticker reduced-motion (`RadarScan`, `SkeletonLoader`)
- [x] Deferred: font monospace (JetBrains Mono terdaftar di pubspec)
- [x] Deferred: wrapper `maxContentWidth` di semua layar (`ContentFrame` via `AppBackground.constrainContent`)
- [x] Deferred: `SystemChrome` status bar gelap (`AppSystemUi.apply()` di `main`)

