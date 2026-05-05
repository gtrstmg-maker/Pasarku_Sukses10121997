# PASARKU SUKSES — CARA PASANG
## Untuk Sutendi — Langkah Demi Langkah

---

## LANGKAH 1 — Buat Project Flutter Baru

Buka terminal, ketik:

    flutter create pasarku_sukses
    cd pasarku_sukses

---

## LANGKAH 2 — Salin Semua File

Salin semua file dari ZIP ini ke dalam folder pasarku_sukses.
Timpa file yang sudah ada.

Struktur akhir harus seperti ini:

    pasarku_sukses/
    ├── pubspec.yaml          ← timpa
    ├── android/
    │   └── app/
    │       └── src/
    │           └── main/
    │               └── AndroidManifest.xml   ← timpa
    └── lib/
        ├── main.dart
        ├── konstanta.dart
        ├── models/
        │   ├── produk.dart
        │   ├── penjual.dart
        │   └── hasil_analisis.dart
        ├── services/
        │   ├── lokal_service.dart
        │   └── analisis_service.dart
        ├── widgets/
        │   └── tombol_besar.dart
        └── screens/
            ├── splash_screen.dart
            ├── main_screen.dart
            ├── foto_screen.dart
            ├── hasil_screen.dart
            ├── scan_screen.dart
            ├── daftar_screen.dart
            ├── produk_screen.dart
            └── profil_screen.dart

---

## LANGKAH 3 — Buat Folder Assets

Buat folder ini di dalam pasarku_sukses:

    assets/
    └── images/

---

## LANGKAH 4 — Ubah minSdkVersion

Buka file:  android/app/build.gradle

Cari baris ini:
    minSdkVersion flutter.minSdkVersion

Ganti menjadi:
    minSdkVersion 21

---

## LANGKAH 5 — Install dan Jalankan

    flutter pub get
    flutter run

Untuk build APK:
    flutter build apk --debug

APK ada di: build/app/outputs/flutter-apk/app-debug.apk

---

## JIKA ADA ERROR

Foto pesan error dan kirim ke Claude. Langsung diperbaiki!

Pasarku Sukses — Muara Angke, Jakarta Utara
