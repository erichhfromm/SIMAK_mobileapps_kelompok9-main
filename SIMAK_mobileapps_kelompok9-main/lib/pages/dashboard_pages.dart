import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../api/api_service.dart';
import '../pages/matakuliah_page.dart';
import '../pages/profile_pages.dart';
import '../pages/input_krs_page.dart';
import '../pages/feedback_pages.dart';
import '../pages/notifikasi_page.dart';
import '../pages/surat_kotak_masuk_page.dart';
import '../pages/tugas_list_page.dart';
import '../pages/e-sertifikat.dart';
import '../pages/nilai_page.dart';
import '../pages/news_page.dart';
import '../pages/transkrip_page.dart';
import '../pages/absensi_list_page.dart';
import '../pages/kartu_mahasiswa_page.dart';
import '../pages/keuangan_page.dart';
import '../pages/remidi_pages.dart';
import '../pages/ujian_pages.dart';
import '../pages/khs_page.dart';

class DashboardPages extends StatefulWidget {
  const DashboardPages({super.key});

  @override
  State<DashboardPages> createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? user;
  bool _isLoading = true;
  String? _errorMessage;
  int _jadwalIndex = 0;
  late AnimationController _animationController;
  int _selectedNavIndex = 0;

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.badge_outlined, "label": "Kartu Mahasiswa"}, // NEW
    {"icon": Icons.article_outlined, "label": "e-sertifikat"},
    {"icon": Icons.menu_book_outlined, "label": "Nilai"},
    {"icon": Icons.newspaper_outlined, "label": "News"},
    {"icon": Icons.assignment_outlined, "label": "KRS"},
    {"icon": Icons.insert_drive_file_outlined, "label": "Transkrip"},
    {"icon": Icons.menu_book_outlined, "label": "Mata Kuliah"},
    {"icon": Icons.account_balance_wallet_outlined, "label": "Keuangan"},
    {"icon": Icons.school_outlined, "label": "KHS"},
    {"icon": Icons.chat_bubble_outline, "label": "Umpan Balik"},
    {"icon": Icons.replay_circle_filled_outlined, "label": "Remidi"},
    {"icon": Icons.fact_check_outlined, "label": "Ujian"},
    {"icon": Icons.check_circle_outline, "label": "Absensi"},
  ];

  final List<Map<String, dynamic>> jadwalDummy = [
    {
      "tanggal": "Senin, 1 Sept 2025",
      "matkul": [
        {"nama": "Mobile Programming", "jam": "08.00 - 10.30"},
        {"nama": "Data Mining", "jam": "13.00 - 15.00"},
      ],
    },
    {
      "tanggal": "Selasa, 2 Sept 2025",
      "matkul": [
        {"nama": "Sistem Basis Data", "jam": "09.00 - 11.00"},
        {"nama": "Kecerdasan Buatan", "jam": "14.00 - 16.00"},
      ],
    },
    {
      "tanggal": "Rabu, 3 Sept 2025",
      "matkul": [
        {"nama": "Pemrograman Web", "jam": "08.00 - 10.00"},
        {"nama": "Mobile Programming", "jam": "10.30 - 12.00"},
      ],
    },
    {
      "tanggal": "Kamis, 4 Sept 2025",
      "matkul": [
        {"nama": "Data Mining", "jam": "09.00 - 11.00"},
        {"nama": "Sistem Basis Data", "jam": "13.00 - 15.00"},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _getMahasiswaData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getMahasiswaData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      final email = prefs.getString("auth_email");

      if (token == null || email == null) {
        throw Exception(
          "Token atau Email tidak ditemukan. Silakan login ulang.",
        );
      }

      Dio dio = Dio()
        ..options.headers = {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        };

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        setState(() {
          user = response.data["data"];
          _isLoading = false;
        });
      } else {
        throw Exception("Gagal memuat data mahasiswa.");
      }
    } catch (e) {
      debugPrint("Error getMahasiswa: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      });
    }
  }

  // 🔵 ROUTING MENU
  void _onMenuTap(String label) {
    final normalized = label.toLowerCase();
    debugPrint("Menu tapped: $label -> $normalized");

    if (normalized.contains("mata kuliah")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DaftarMatakuliahPage()),
      );
    } else if (normalized.contains("kartu mahasiswa") ||
        normalized.contains("ktm")) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KartuMahasiswaPage(user: user!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data mahasiswa belum siap")),
        );
      }
    } else if (normalized.contains("krs")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InputKrsPage()),
      );
    } else if (normalized.contains("profil")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePages()),
      );
    } else if (normalized.contains("surat")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuratKotakMasukPage()),
      );
    } else if (normalized.contains("notifikasi")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotifikasiPage()),
      );
    } else if (normalized.contains("umpan balik") ||
        normalized.contains("feedback")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeedbackPages()),
      );
    }
    // ⭐ MENU NILAI
    else if (normalized.contains("nilai")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NilaiPage()),
      );
    }
    // ⭐ MENU E-SERTIFIKAT
    else if (normalized.contains("e-sertifikat")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ESertifikatPage()),
      );
    }
    // ⭐ MENU NEWS (DITAMBAHKAN)
    else if (normalized.contains("news")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsPage()),
      );
    }
    // ⭐ MENU TRANSKRIP
    else if (normalized.contains("transkrip")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TranskripPage()),
      );
    }
    // ⭐ MENU ABSENSI
    else if (normalized.contains("absensi") || normalized.contains("absen")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AbsensiListPage()),
      );
    }
    // ⭐ MENU KEUANGAN
    else if (normalized.contains("keuangan")) {
      debugPrint("Navigating to KeuanganPage");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KeuanganPage()),
      );
    }
    // ⭐ MENU KHS
    else if (normalized.contains("khs")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KHSPage()),
      );
    }
    // ⭐ MENU REMIDI
    else if (normalized.contains("remidi")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RemidiPages()),
      );
    }
    // ⭐ MENU UJIAN
    else if (normalized.contains("ujian")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UjianPages()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF4C7F9A),
          content: Text('Menu "$label" belum tersedia'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        elevation: 8,
        shadowColor: const Color(0xFF4C7F9A).withOpacity(0.3),
        centerTitle: true,
        title: const Text(
          "Dashboard Mahasiswa",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _modernBottomNavbar(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4C7F9A)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                "Gagal Memuat Data",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _getMahasiswaData,
                icon: const Icon(Icons.refresh),
                label: const Text("Coba Lagi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C7F9A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _dashboardContent();
  }

  // 🟦 MAIN DASHBOARD CONTENT
  Widget _dashboardContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileHeader(),
            const SizedBox(height: 20),

            _searchBar(),
            const SizedBox(height: 20),

            _jadwalCard(),
            const SizedBox(height: 25),

            _tugasHeader(),
            const SizedBox(height: 14),

            _tugasCard(
              "Mobile Programming",
              "Tugas Layout Login",
              "12 Jan 2025",
            ),
            const SizedBox(height: 10),
            _tugasCard("Data Mining", "Preprocessing Dataset", "18 Jan 2025"),
            const SizedBox(height: 30),

            _menuAkademik(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔹 Profil Header dengan Gradient
  Widget _profileHeader() {
    final hasFoto =
        (user?["foto"] != null &&
        (user?["foto"]?.toString().isNotEmpty ?? false));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C7F9A).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'profile_avatar',
            child: CircleAvatar(
              radius: 40,
              backgroundImage: hasFoto
                  ? NetworkImage(user!["foto"])
                  : const AssetImage("assets/images/default_user.png")
                        as ImageProvider,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?["nama"] ?? "-",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Mahasiswa - ${user?["program_studi"]?["nama_prodi"] ?? '-'}",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Search Bar dengan Animasi
  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Cari mata kuliah, tugas...",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: Icon(Icons.tune_rounded, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  // 🔹 Jadwal Card dengan Animasi
  Widget _jadwalCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C7F9A), Color(0xFF5A8FAC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C7F9A).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "📅 JADWAL HARI INI",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Aktif",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        jadwalDummy[_jadwalIndex]["tanggal"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _jadwalNavButton(
                      Icons.arrow_back_ios,
                      onPressed: () => setState(
                        () => _jadwalIndex = (_jadwalIndex > 0)
                            ? _jadwalIndex - 1
                            : 0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: List.generate(
                            jadwalDummy[_jadwalIndex]["matkul"].length,
                            (i) {
                              final m = jadwalDummy[_jadwalIndex]["matkul"][i];
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      i !=
                                          jadwalDummy[_jadwalIndex]["matkul"]
                                                  .length -
                                              1
                                      ? 12
                                      : 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 4,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4C7F9A),
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                m["nama"],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                m["jam"],
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (i !=
                                        jadwalDummy[_jadwalIndex]["matkul"]
                                                .length -
                                            1)
                                      Divider(
                                        color: Colors.grey.shade300,
                                        height: 16,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    _jadwalNavButton(
                      Icons.arrow_forward_ios,
                      onPressed: () => setState(() {
                        if (_jadwalIndex < jadwalDummy.length - 1) {
                          _jadwalIndex++;
                        }
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk tombol navigasi jadwal
  Widget _jadwalNavButton(IconData icon, {required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 18),
        splashRadius: 20,
      ),
    );
  }

  // 🔹 Header Tugas
  Widget _tugasHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Tugasku",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4C7F9A),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TugasListPage()),
            );
          },
          child: const Text(
            "Lihat Semua",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xFF4C7F9A),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Card Tugas dengan Animasi
  Widget _tugasCard(String matkul, String judul, String deadline) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TugasListPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    matkul,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Color(0xFF4C7F9A),
                ),
                const SizedBox(height: 4),
                Text(
                  deadline,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4C7F9A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Menu Akademik (Grid) dengan Efek Hover
  Widget _menuAkademik() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🎓 Menu Akademikku",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.9,
          crossAxisSpacing: 10,
          mainAxisSpacing: 14,
          children: List.generate(menuItems.length, (index) {
            final item = menuItems[index];
            final List<Color> colorOptions = [
              const Color(0xFFD7C5F7),
              const Color(0xFFA7D8F7),
              const Color(0xFFB7E4C7),
              const Color(0xFFFFE6A7),
              const Color(0xFFFFB6A7),
              const Color(0xFFE0E0E0),
              const Color(0xFFF8C6D8),
            ];

            return _buildMenuItemModern(
              item["icon"],
              item["label"],
              colorOptions[index % colorOptions.length],
              onTap: () => _onMenuTap(item["label"]),
            );
          }),
        ),
      ],
    );
  }

  // Widget untuk menu item modern
  Widget _buildMenuItemModern(
    IconData icon,
    String label,
    Color bgColor, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bgColor, bgColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: const Color(0xFF3E657A), size: 28),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF3E657A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Modern Bottom Navbar
  Widget _modernBottomNavbar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navbarItem(
                Icons.mail_outline_rounded,
                "Pesan",
                0,
                onTap: () {
                  setState(() => _selectedNavIndex = 0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuratKotakMasukPage(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 60),
              _navbarItem(
                Icons.person_outline_rounded,
                "Profil",
                1,
                onTap: () {
                  setState(() => _selectedNavIndex = 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePages(),
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: -25,
            left: MediaQuery.of(context).size.width / 2 - 32.5,
            child: GestureDetector(
              onTap: () {
                // Refresh data when home button is tapped
                _getMahasiswaData();
              },
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4C7F9A),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4C7F9A).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Material(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.home_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk navbar item
  Widget _navbarItem(
    IconData icon,
    String label,
    int index, {
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedNavIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF4C7F9A)
                  : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? const Color(0xFF4C7F9A)
                    : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
