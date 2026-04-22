# Dokumentasi Ujian Pages

## File yang Dibuat
- **File**: `lib/pages/ujian_pages.dart`
- **Tanggal**: 2025-12-05

## Deskripsi
Halaman Jadwal Ujian Mahasiswa yang terintegrasi dengan sistem SIMAK. Halaman ini memungkinkan mahasiswa untuk:
1. Melihat jadwal ujian yang akan datang
2. Melihat detail lengkap setiap ujian
3. Mendapatkan countdown/pengingat ujian
4. Melihat riwayat ujian yang sudah dilaksanakan
5. Melihat hasil nilai ujian

## Fitur Utama

### Tab 1: Ujian Mendatang
- **Summary Card**: Menampilkan ujian terdekat dengan countdown
- **Daftar Ujian**: Semua ujian yang dijadwalkan, diurutkan berdasarkan tanggal
- **Informasi Detail**:
  - Jenis ujian (UTS, UAS, Quiz)
  - Mata kuliah dan kode MK
  - Dosen pengampu
  - Tanggal, hari, dan waktu
  - Durasi ujian
  - Ruangan dan gedung
  - Sifat ujian (Open Book/Close Book)
  - Materi yang diujikan
  - Catatan penting
- **Countdown Timer**: Menampilkan berapa hari lagi ujian
- **Urgent Alert**: Highlight merah untuk ujian yang tinggal 3 hari atau kurang

### Tab 2: Riwayat Ujian
- Daftar ujian yang sudah selesai
- Menampilkan nilai dan skor
- Informasi tanggal pelaksanaan
- Detail lengkap ujian yang sudah dilaksanakan

### Detail View (Bottom Sheet)
- Modal bottom sheet yang dapat di-drag
- Informasi lengkap ujian
- Materi ujian
- Catatan penting dengan highlight
- Hasil nilai (untuk ujian yang sudah selesai)

## Integrasi

### Dashboard Integration
File `dashboard_pages.dart` telah diupdate dengan:
1. Import statement untuk `ujian_pages.dart`
2. Routing di fungsi `_onMenuTap()` untuk menu "Ujian"

### Navigasi
Dari Dashboard → Menu Akademik → Ujian

## Desain UI/UX

### Warna Tema
- Primary: `Color(0xFF4C7F9A)` (Biru)
- Background: `Color(0xFFF5F7FA)` (Abu-abu terang)
- UTS: `Colors.blue`
- UAS: `Colors.red`
- Quiz: `Colors.green`
- Urgent: `Colors.red` (untuk ujian < 3 hari)

### Komponen UI
1. **Summary Card**: Gradient card dengan info ujian terdekat
2. **Ujian Card**: Card dengan color-coded jenis ujian
3. **Countdown Badge**: Badge dengan countdown hari tersisa
4. **Urgent Indicator**: Border merah untuk ujian mendesak
5. **Bottom Sheet**: Draggable modal untuk detail lengkap
6. **Status Badge**: Badge berwarna untuk jenis ujian (UTS/UAS/Quiz)
7. **Nilai Display**: Gradient card untuk menampilkan hasil

### Icon Mapping
- **UTS**: `Icons.assignment`
- **UAS**: `Icons.school`
- **Quiz**: `Icons.quiz`

## Data Structure

### Ujian Mendatang
```dart
{
  "id": String,
  "jenis": String, // "UTS", "UAS", "Quiz"
  "matakuliah": String,
  "kode_mk": String,
  "dosen": String,
  "tanggal": String, // "2025-12-15"
  "hari": String, // "Senin"
  "waktu_mulai": String, // "08:00"
  "waktu_selesai": String, // "10:00"
  "durasi": String, // "120 menit"
  "ruangan": String,
  "gedung": String,
  "sifat": String, // "Open Book" / "Close Book"
  "materi": String,
  "catatan": String,
  "status": String, // "Akan Datang"
  "hari_tersisa": int,
}
```

### Ujian Selesai
```dart
{
  "id": String,
  "jenis": String,
  "matakuliah": String,
  "kode_mk": String,
  "dosen": String,
  "tanggal": String,
  "hari": String,
  "waktu_mulai": String,
  "waktu_selesai": String,
  "ruangan": String,
  "nilai": String, // "A", "B+", etc.
  "skor": int, // 0-100
  "status": String, // "Selesai"
}
```

## Fitur Khusus

### 1. Auto-Sort
- **Ujian Mendatang**: Diurutkan berdasarkan `hari_tersisa` (ascending)
- **Riwayat Ujian**: Diurutkan berdasarkan `tanggal` (descending)

### 2. Urgent Detection
- Ujian dengan `hari_tersisa <= 3` akan ditandai sebagai urgent
- Border merah dan background highlight
- Icon warning

### 3. Color-Coded Jenis Ujian
- Setiap jenis ujian memiliki warna berbeda
- Konsisten di seluruh UI (badge, icon background, dll)

### 4. Interactive Detail View
- Tap pada card untuk melihat detail lengkap
- Bottom sheet yang dapat di-drag
- Smooth animation

### 5. Pull to Refresh
- Kedua tab mendukung pull-to-refresh
- Loading indicator dengan warna tema

## TODO / Pengembangan Selanjutnya

1. **API Integration**
   - Endpoint untuk fetch jadwal ujian
   - Endpoint untuk fetch riwayat ujian
   - Endpoint untuk fetch detail ujian
   - Real-time sync dengan kalender akademik

2. **Fitur Tambahan**
   - **Notifikasi Push**: Reminder H-7, H-3, H-1
   - **Kalender View**: Tampilan kalender untuk jadwal ujian
   - **Export to Calendar**: Export ke Google Calendar/iCal
   - **Download Kartu Ujian**: Download kartu peserta ujian
   - **Filter**: Filter berdasarkan jenis ujian, semester
   - **Search**: Pencarian mata kuliah
   - **Statistik**: Grafik performa ujian
   - **Study Timer**: Timer belajar untuk persiapan ujian

3. **Validasi & Reminder**
   - Validasi konflik jadwal
   - Reminder otomatis
   - Countdown widget di dashboard
   - Badge notifikasi untuk ujian mendesak

4. **Offline Support**
   - Cache jadwal ujian
   - Offline access untuk jadwal yang sudah di-load
   - Sync saat online kembali

## Catatan Penting

- Saat ini menggunakan **dummy data** untuk demonstrasi
- Perlu mengganti dengan API call yang sebenarnya di fungsi `_loadUjianData()`
- Token authentication sudah diimplementasikan (menggunakan SharedPreferences)
- Error handling sudah ada dengan tampilan error state dan retry button
- Pull to refresh sudah diimplementasikan
- Bottom sheet detail view sudah responsive

## Dependencies
- `flutter/material.dart`
- `shared_preferences` - untuk menyimpan token dan session

## Testing Checklist
Untuk testing, pastikan:
- [x] User sudah login (ada token di SharedPreferences)
- [x] Navigasi dari dashboard berfungsi
- [x] Tab switching berfungsi dengan smooth
- [x] Summary card menampilkan ujian terdekat
- [x] Countdown hari tersisa akurat
- [x] Urgent indicator muncul untuk ujian < 3 hari
- [x] Bottom sheet detail dapat dibuka dengan tap
- [x] Bottom sheet dapat di-drag
- [x] Pull to refresh berfungsi di kedua tab
- [x] Color coding jenis ujian konsisten
- [x] Sorting data bekerja dengan benar
- [x] Empty state ditampilkan jika tidak ada data
- [x] Error state dan retry button berfungsi

## UI/UX Highlights

### 1. Visual Hierarchy
- Jenis ujian dibedakan dengan warna
- Ujian urgent mendapat perhatian khusus
- Informasi penting di-highlight

### 2. Information Architecture
- Informasi tersusun rapi dan mudah dibaca
- Detail lengkap tersedia tanpa overload
- Progressive disclosure dengan bottom sheet

### 3. User Feedback
- Loading states yang jelas
- Error handling yang informatif
- Empty states yang friendly
- Smooth animations

### 4. Accessibility
- Icon yang intuitif
- Text yang readable
- Color contrast yang baik
- Touch targets yang cukup besar

## Perbandingan dengan Remidi Pages

| Aspek | Ujian Pages | Remidi Pages |
|-------|-------------|--------------|
| Tujuan | Jadwal & Hasil Ujian | Pendaftaran Remidi |
| Interaksi | View Only | Daftar/Batalkan |
| Data | Jadwal + Hasil | Tersedia + Terdaftar |
| Urgency | Countdown Timer | Kuota Tersisa |
| Action | Lihat Detail | Daftar/Batalkan |

Kedua halaman menggunakan design system yang sama untuk konsistensi UI/UX.
