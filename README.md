# Bento Lookbook — Aplikasi Flutter Gesture Interaktif

Aplikasi mobile interaktif berbasis Flutter yang menggabungkan penerapan **Layout Kompleks** (*Stack, Row, Column, Bento Card*) dengan **Manipulasi Gesture Interaktif** secara visual dan *real-time*.

Aplikasi ini mengusung tema **Editorial Lookbook & Sustainable Fashion (SDG 12)** dengan desain modular bergaya **Bento Grid**.

---

## 👥 Tim Pengembang

| No | Nama Lengkap | NIM | Peran |
| :---: | :--- | :---: | :---: |
| 1 | **Muhammad Malik Abdul Aziz** | `202431158` | **Ketua Tim** |
| 2 | **Raihan Daris Ramadhan** | `202431033` | Anggota |

---

## 📌 Pemenuhan Ketentuan Tugas

### 1. Implementasi 3 Gesture Interaktif Wajib

| Gesture | Widget Utama | Aksi Interaksi Pengguna | Respon & Perubahan State Visual |
| :--- | :--- | :--- | :--- |
| **Double Tap** | `GestureDetector` | Ketuk dua kali (*double tap*) pada area kartu header hero. | **Perubahan warna visual global**: Beralih tema secara real-time antara *Light Mode* (Off-white & Cobalt Blue) dan *Dark Mode* (Obsidian & Acid Lime) menggunakan `setState`. |
| **Scale / Pinch** | `InteractiveViewer` | Cubit layar (*pinch to zoom*) menggunakan dua jari dan geser (*pan*) pada gambar lookbook. | **Transformasi ukuran & posisi**: Gambar membesar/mengecil (skala 1.0x – 5.0x) secara fluid dalam batas kartu. Memunculkan tombol interaktif **RESET** saat gambar diperbesar. |
| **Swipe / Horizontal Drag** | `Dismissible` | Geser kartu item moodboard ke arah kiri (*end-to-start*). | **Animasi geser & pop-up interaktif**: Kartu bergeser dengan latar belakang merah bertuliskan *HAPUS*, item terhapus dari state daftar, dan memicu *floating* `SnackBar` berisi tombol **UNDO**. |

---

### 2. Implementasi Layout Kompleks

Aplikasi ini mengombinasikan berbagai widget tata letak hierarki untuk menyusun UI yang kaya dan responsif:

* **`Column`**: 
  * Menata alur layout utama dari atas ke bawah (Header → Gambar Interaktif → Moodboard).
  * Menyusun hierarki teks headline editorial dan tampilan *empty state*.
* **`Row`**: 
  * Menata elemen horizontal, seperti tag SDG bersama tombol pill tema.
  * Menata baris header daftar moodboard bersama indikator hitungan dan ikon geser.
  * Menata isi item kartu (nomor urut, judul item, dan panah navigasi).
* **`Stack`**: 
  * Digunakan pada kartu gambar untuk menumpuk lapisan:
    1. Latar gambar interaktif (`InteractiveViewer`).
    2. Tag kategori melayang di pojok kiri atas (`LOOKBOOK // 01`).
    3. Tombol aksi melayang `RESET` di pojok kanan atas saat gambar di-zoom.
    4. Kapsul petunjuk melayang `PINCH TO ZOOM` di pojok kanan bawah.
* **`Card` / Bento Container**: 
  * Diimplementasikan melalui metode modular `_cardDecor()` yang menghasilkan container kartu bergaya bento dengan sudut membulat (`border-radius: 20px`), border bergaris tegas, dan bayangan (*box-shadow*) halus.

---

### 3. Manajemen State & Arsitektur Kode

* **State Management Lokal Bersih**: Seluruh interaksi dikelola menggunakan `setState` pada `StatefulWidget` (`_LookbookScreenState`). State yang dikelola:
  * `isDarkMode` (bool): Menyimpan status tema aktif.
  * `moodboardItems` (List<String>): Menyimpan data item moodboard yang reaktif terhadap aksi hapus dan undo.
  * `_isZoomed` (bool): Mendeteksi skala gambar apakah melebihi skala default (1.0x).
* **Modularitas & Kerapian Kode**:
  * `_buildHeader()`: Modul kartu atas dengan double-tap theme switcher.
  * `_buildImageCard()`: Modul kartu tengah dengan gesture scale/pinch zoom.
  * `_buildMoodboardCard()`: Modul kartu bawah pengelola daftar item moodboard.
  * `_buildMoodboardList()` & `_buildEmptyMoodboard()`: Modul daftar dan tampilan kosong (*empty state*).
  * `_ThemeColors`: Helper class palet warna adaptif untuk mode terang dan gelap.
  * `_cardDecor()` & `_badge()`: Komponen reusable untuk styling bento dan label overlay.
* **Dokumentasi Kode**: Setiap baris komentar dibuat ringkas 1 baris dalam bahasa Indonesia untuk menjaga keterbacaan kode (*clean code*).

---

## 📁 Struktur Berkas

```text
lib/
└── main.dart            # Seluruh implementasi aplikasi (modular & ringkas)
assets/
└── images/
    └── skate.jpg        # Aset gambar lokal untuk eksplorasi gesture pinch
test/
└── widget_test.dart     # Pengujian widget (smoke test & pengujian gesture)
pubspec.yaml             # Konfigurasi dependensi dan deklarasi aset gambar
README.md                # Dokumentasi proyek
```

---

## 🚀 Cara Menjalankan Aplikasi

1. **Pastikan Flutter SDK sudah terpasang**:
   ```bash
   flutter doctor
   ```

2. **Unduh seluruh dependensi proyek**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi pada perangkat/emulator**:
   ```bash
   flutter run
   ```
   *Atau pilih target spesifik, misalnya Chrome / Web:*
   ```bash
   flutter run -d chrome
   ```
