import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UjianPages extends StatefulWidget {
  const UjianPages({super.key});

  @override
  State<UjianPages> createState() => _UjianPagesState();
}

class _UjianPagesState extends State<UjianPages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;

  // Data Ujian
  List<Map<String, dynamic>> _ujianMendatang = [];
  List<Map<String, dynamic>> _ujianSelesai = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUjianData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load data ujian dari API atau dummy data
  Future<void> _loadUjianData() async {
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

      // Catatan: Ganti dengan API call yang sebenarnya
      // Untuk saat ini menggunakan dummy data
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _ujianMendatang = [
          {
            "id": "UTS-001",
            "jenis": "UTS",
            "matakuliah": "Pemrograman Mobile",
            "kode_mk": "TIF401",
            "dosen": "Dr. Budi Santoso",
            "tanggal": "2025-12-15",
            "hari": "Senin",
            "waktu_mulai": "08:00",
            "waktu_selesai": "10:00",
            "durasi": "120 menit",
            "ruangan": "Lab Komputer 1",
            "gedung": "Gedung A",
            "sifat": "Close Book",
            "materi": "Layout & Navigation, State Management, Widget Lifecycle",
            "catatan":
                "Membawa laptop dan charger. Pastikan Flutter SDK sudah terinstall.",
            "status": "Akan Datang",
            "hari_tersisa": 10,
          },
          {
            "id": "UTS-002",
            "jenis": "UTS",
            "matakuliah": "Basis Data",
            "kode_mk": "TIF301",
            "dosen": "Siti Rahma, M.Kom",
            "tanggal": "2025-12-18",
            "hari": "Kamis",
            "waktu_mulai": "13:00",
            "waktu_selesai": "15:00",
            "durasi": "120 menit",
            "ruangan": "Ruang 301",
            "gedung": "Gedung B",
            "sifat": "Open Book",
            "materi":
                "SQL Advanced, Normalisasi Database, Transaction & Concurrency",
            "catatan": "Boleh membawa catatan dan buku referensi.",
            "status": "Akan Datang",
            "hari_tersisa": 13,
          },
          {
            "id": "QUIZ-001",
            "jenis": "Quiz",
            "matakuliah": "Kecerdasan Buatan",
            "kode_mk": "TIF501",
            "dosen": "Indra Saputra, M.T",
            "tanggal": "2025-12-12",
            "hari": "Jumat",
            "waktu_mulai": "10:00",
            "waktu_selesai": "11:00",
            "durasi": "60 menit",
            "ruangan": "Ruang 205",
            "gedung": "Gedung C",
            "sifat": "Close Book",
            "materi": "Machine Learning Basics, Neural Networks",
            "catatan": "Quiz online menggunakan platform e-learning.",
            "status": "Akan Datang",
            "hari_tersisa": 7,
          },
          {
            "id": "UAS-001",
            "jenis": "UAS",
            "matakuliah": "Algoritma & Struktur Data",
            "kode_mk": "TIF201",
            "dosen": "Agus Setiawan, M.Kom",
            "tanggal": "2025-12-28",
            "hari": "Sabtu",
            "waktu_mulai": "08:00",
            "waktu_selesai": "10:30",
            "durasi": "150 menit",
            "ruangan": "Aula Utama",
            "gedung": "Gedung A",
            "sifat": "Close Book",
            "materi": "Sorting, Searching, Tree, Graph, Dynamic Programming",
            "catatan":
                "Ujian komprehensif. Membawa alat tulis dan kalkulator non-programmable.",
            "status": "Akan Datang",
            "hari_tersisa": 23,
          },
        ];

        _ujianSelesai = [
          {
            "id": "UTS-003",
            "jenis": "UTS",
            "matakuliah": "Pemrograman Web",
            "kode_mk": "TIF302",
            "dosen": "Rina Kusuma, M.T",
            "tanggal": "2025-11-20",
            "hari": "Rabu",
            "waktu_mulai": "08:00",
            "waktu_selesai": "10:00",
            "ruangan": "Lab Komputer 2",
            "nilai": "A",
            "skor": 92,
            "status": "Selesai",
          },
          {
            "id": "QUIZ-002",
            "jenis": "Quiz",
            "matakuliah": "Sistem Operasi",
            "kode_mk": "TIF303",
            "dosen": "Ahmad Fauzi, M.Kom",
            "tanggal": "2025-11-15",
            "hari": "Senin",
            "waktu_mulai": "13:00",
            "waktu_selesai": "14:00",
            "ruangan": "Ruang 401",
            "nilai": "B+",
            "skor": 85,
            "status": "Selesai",
          },
          {
            "id": "UTS-004",
            "jenis": "UTS",
            "matakuliah": "Jaringan Komputer",
            "kode_mk": "TIF304",
            "dosen": "Dewi Sartika, M.T",
            "tanggal": "2025-11-10",
            "hari": "Jumat",
            "waktu_mulai": "10:00",
            "waktu_selesai": "12:00",
            "ruangan": "Ruang 302",
            "nilai": "A-",
            "skor": 88,
            "status": "Selesai",
          },
        ];

        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading ujian data: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      });
    }
  }

  // Tampilkan detail ujian
  void _showDetailUjian(Map<String, dynamic> ujian) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getJenisIcon(ujian["jenis"]),
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ujian["matakuliah"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${ujian['kode_mk'] ?? ''} • ${ujian['jenis']}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Informasi Ujian
                      _buildSectionTitle("Informasi Ujian"),
                      const SizedBox(height: 12),
                      _buildDetailInfoCard([
                        {
                          "icon": Icons.person,
                          "label": "Dosen Pengampu",
                          "value": ujian["dosen"],
                        },
                        {
                          "icon": Icons.calendar_today,
                          "label": "Tanggal",
                          "value": "${ujian['hari']}, ${ujian['tanggal']}",
                        },
                        {
                          "icon": Icons.access_time,
                          "label": "Waktu",
                          "value":
                              "${ujian['waktu_mulai']} - ${ujian['waktu_selesai']}",
                        },
                        {
                          "icon": Icons.timer,
                          "label": "Durasi",
                          "value": ujian["durasi"] ?? "-",
                        },
                        {
                          "icon": Icons.room,
                          "label": "Ruangan",
                          "value":
                              "${ujian['ruangan']} - ${ujian['gedung'] ?? ''}",
                        },
                        if (ujian["sifat"] != null)
                          {
                            "icon": Icons.menu_book,
                            "label": "Sifat Ujian",
                            "value": ujian["sifat"],
                          },
                      ]),

                      if (ujian["materi"] != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle("Materi Ujian"),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4C7F9A,
                            ).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFF4C7F9A,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            ujian["materi"],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],

                      if (ujian["catatan"] != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle("Catatan Penting"),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  ujian["catatan"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orange.shade900,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (ujian["nilai"] != null) ...[
                        const SizedBox(height: 24),
                        _buildSectionTitle("Hasil Ujian"),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Nilai",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ujian["nilai"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Skor",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${ujian['skor']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getJenisIcon(String jenis) {
    switch (jenis.toUpperCase()) {
      case 'UTS':
        return Icons.assignment;
      case 'UAS':
        return Icons.school;
      case 'QUIZ':
        return Icons.quiz;
      default:
        return Icons.description;
    }
  }

  Color _getJenisColor(String jenis) {
    switch (jenis.toUpperCase()) {
      case 'UTS':
        return Colors.blue;
      case 'UAS':
        return Colors.red;
      case 'QUIZ':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Jadwal Ujian",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Ujian Mendatang"),
            Tab(text: "Riwayat Ujian"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4C7F9A)),
            )
          : _errorMessage != null
          ? _buildErrorState()
          : TabBarView(
              controller: _tabController,
              children: [_buildUjianMendatangTab(), _buildRiwayatUjianTab()],
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
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
              onPressed: _loadUjianData,
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

  Widget _buildUjianMendatangTab() {
    // Sort by hari_tersisa
    _ujianMendatang.sort(
      (a, b) => a["hari_tersisa"].compareTo(b["hari_tersisa"]),
    );

    return RefreshIndicator(
      onRefresh: _loadUjianData,
      color: const Color(0xFF4C7F9A),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            const Text(
              "Jadwal Ujian",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            if (_ujianMendatang.isEmpty)
              _buildEmptyState("Tidak ada ujian yang dijadwalkan saat ini.")
            else
              ..._ujianMendatang.map((item) => _buildUjianMendatangCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatUjianTab() {
    // Sort by tanggal descending
    _ujianSelesai.sort((a, b) => b["tanggal"].compareTo(a["tanggal"]));

    return RefreshIndicator(
      onRefresh: _loadUjianData,
      color: const Color(0xFF4C7F9A),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Riwayat Ujian",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            if (_ujianSelesai.isEmpty)
              _buildEmptyState("Belum ada riwayat ujian.")
            else
              ..._ujianSelesai.map((item) => _buildRiwayatUjianCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final ujianTerdekat = _ujianMendatang.isNotEmpty
        ? _ujianMendatang.first
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C7F9A).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_note,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ujian Terdekat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Persiapkan diri Anda dengan baik",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (ujianTerdekat != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ujianTerdekat["matakuliah"],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getJenisColor(ujianTerdekat["jenis"]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ujianTerdekat["jenis"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${ujianTerdekat['hari']}, ${ujianTerdekat['tanggal']}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${ujianTerdekat['waktu_mulai']} - ${ujianTerdekat['waktu_selesai']}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.orange.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${ujianTerdekat['hari_tersisa']} hari lagi",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
            const Text(
              "Tidak ada ujian yang dijadwalkan",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUjianMendatangCard(Map<String, dynamic> item) {
    final jenisColor = _getJenisColor(item["jenis"]);
    final isUrgent = item["hari_tersisa"] <= 3;

    return GestureDetector(
      onTap: () => _showDetailUjian(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent ? Colors.red.shade200 : Colors.grey.shade200,
            width: isUrgent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: jenisColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: jenisColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getJenisIcon(item["jenis"]),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: jenisColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item["jenis"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item["kode_mk"],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["matakuliah"],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["dosen"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.calendar_today,
                          "${item['hari']}, ${item['tanggal']}",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.access_time,
                          "${item['waktu_mulai']} - ${item['waktu_selesai']}",
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(Icons.timer, item["durasi"]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoItem(
                    Icons.room,
                    "${item['ruangan']} - ${item['gedung']}",
                  ),
                  const SizedBox(height: 16),
                  // Countdown
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.red.shade50
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isUrgent
                            ? Colors.red.shade200
                            : Colors.blue.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isUrgent
                              ? Icons.warning_amber
                              : Icons.event_available,
                          color: isUrgent
                              ? Colors.red.shade700
                              : Colors.blue.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isUrgent
                              ? "SEGERA! ${item['hari_tersisa']} hari lagi"
                              : "${item['hari_tersisa']} hari lagi",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isUrgent
                                ? Colors.red.shade900
                                : Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatUjianCard(Map<String, dynamic> item) {
    final jenisColor = _getJenisColor(item["jenis"]);

    return GestureDetector(
      onTap: () => _showDetailUjian(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: jenisColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getJenisIcon(item["jenis"]),
                color: jenisColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: jenisColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item["jenis"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item["kode_mk"],
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["matakuliah"],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item['hari']}, ${item['tanggal']}",
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C7F9A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    item["nilai"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C7F9A),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Skor: ${item['skor']}",
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4C7F9A)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildDetailInfoCard(List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item["icon"], size: 18, color: const Color(0xFF4C7F9A)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["label"],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item["value"],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (index < items.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Colors.grey.shade300, height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
