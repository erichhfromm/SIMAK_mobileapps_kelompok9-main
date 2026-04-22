# Dokumentasi Remidi Pages

## File yang Dibuat
- **File**: `lib/pages/remidi_pages.dart`
- **Tanggal**: 2025-12-05

## Deskripsi
Halaman Remidi Mahasiswa yang terintegrasi dengan sistem SIMAK. Halaman ini memungkinkan mahasiswa untuk:
1. Melihat daftar remidi yang tersedia
2. Mendaftar untuk mengikuti remidi
3. Melihat remidi yang sudah didaftarkan
4. Membatalkan pendaftaran remidi
5. Melihat hasil nilai remidi

## Fitur Utama

### Tab 1: Remidi Tersedia
- Menampilkan daftar mata kuliah yang tersedia untuk remidi
- Informasi detail: mata kuliah, dosen, tanggal, waktu, ruangan
- Menampilkan kuota dan jumlah pendaftar
- Menampilkan materi yang akan diujikan
- Menampilkan syarat untuk mengikuti remidi
- Tombol untuk mendaftar remidi
- Indikator kuota penuh

### Tab 2: Remidi Saya
- Menampilkan daftar remidi yang sudah didaftarkan
- Menampilkan nilai awal dan nilai remidi (jika sudah ada)
- Informasi jadwal dan ruangan
- Catatan khusus untuk persiapan
- Tombol untuk membatalkan pendaftaran (jika belum selesai)

## Integrasi

### Dashboard Integration
File `dashboard_pages.dart` telah diupdate dengan:
1. Import statement untuk `remidi_pages.dart`
2. Routing di fungsi `_onMenuTap()` untuk menu "Remidi"

### Navigasi
Dari Dashboard → Menu Akademik → Remidi

## Desain UI/UX

### Warna Tema
- Primary: `Color(0xFF4C7F9A)` (Biru)
- Background: `Color(0xFFF5F7FA)` (Abu-abu terang)
- Success: `Colors.green`
- Warning: `Colors.orange`
- Danger: `Colors.red`

### Komponen UI
1. **Info Card**: Gradient card dengan informasi penting
2. **Remidi Card**: Card dengan border dan shadow untuk setiap item
3. **Status Badge**: Badge berwarna untuk status (Tersedia, Terdaftar, Selesai)
4. **Progress Bar**: Indikator kuota pendaftaran
5. **Dialog**: Konfirmasi untuk pendaftaran dan pembatalan

## Data Structure

### Remidi Tersedia
```dart
{
  "id": String,
  "matakuliah": String,
  "dosen": String,
  "nilai_awal": String,
  "tanggal_remidi": String,
  "waktu": String,
  "ruangan": String,
  "status": String,
  "kuota": int,
  "terdaftar": int,
  "materi": String,
  "syarat": String,
}
```

### Remidi Saya
```dart
{
  "id": String,
  "matakuliah": String,
  "dosen": String,
  "nilai_awal": String,
  "tanggal_remidi": String,
  "waktu": String,
  "ruangan": String,
  "status": String,
  "nilai_remidi": String?, // nullable
  "materi": String,
  "catatan": String?,
}
```

## TODO / Pengembangan Selanjutnya

1. **API Integration**
   - Implementasi endpoint untuk fetch data remidi
   - Endpoint untuk daftar remidi
   - Endpoint untuk batalkan remidi
   - Endpoint untuk get hasil nilai remidi

2. **Fitur Tambahan**
   - Filter berdasarkan semester
   - Search functionality
   - Notifikasi untuk pengingat jadwal remidi
   - Download sertifikat/bukti pendaftaran
   - History remidi dari semester sebelumnya

3. **Validasi**
   - Validasi syarat sebelum mendaftar (nilai, kehadiran)
   - Validasi waktu pendaftaran
   - Validasi konflik jadwal

## Catatan Penting

- Saat ini menggunakan **dummy data** untuk demonstrasi
- Perlu mengganti dengan API call yang sebenarnya di fungsi `_loadRemidiData()`
- Token authentication sudah diimplementasikan (menggunakan SharedPreferences)
- Error handling sudah ada dengan tampilan error state dan retry button
- Pull to refresh sudah diimplementasikan

## Dependencies
- `flutter/material.dart`
- `shared_preferences` - untuk menyimpan token dan session

## Testing
Untuk testing, pastikan:
1. User sudah login (ada token di SharedPreferences)
2. Navigasi dari dashboard berfungsi
3. Tab switching berfungsi
4. Dialog konfirmasi muncul saat daftar/batalkan
5. Pull to refresh berfungsi
