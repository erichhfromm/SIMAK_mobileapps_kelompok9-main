import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemidiPages extends StatefulWidget {
  const RemidiPages({super.key});

  @override
  State<RemidiPages> createState() => _RemidiPagesState();
}

class _RemidiPagesState extends State<RemidiPages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;

  // Data Remidi
  List<Map<String, dynamic>> _remidiTersedia = [];
  List<Map<String, dynamic>> _remidiSaya = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRemidiData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load data remidi dari API atau dummy data
  Future<void> _loadRemidiData() async {
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
        _remidiTersedia = [
          {
            "id": "RMD-001",
            "matakuliah": "Pemrograman Mobile",
            "dosen": "Dr. Budi Santoso",
            "nilai_awal": "D",
            "tanggal_remidi": "2025-12-15",
            "waktu": "08:00 - 10:00",
            "ruangan": "Lab Komputer 1",
            "status": "Tersedia",
            "kuota": 30,
            "terdaftar": 12,
            "materi": "Layout & Navigation, State Management",
            "syarat": "Nilai minimal D, Kehadiran minimal 75%",
          },
          {
            "id": "RMD-002",
            "matakuliah": "Basis Data",
            "dosen": "Siti Rahma, M.Kom",
            "nilai_awal": "C",
            "tanggal_remidi": "2025-12-18",
            "waktu": "13:00 - 15:00",
            "ruangan": "Ruang 301",
            "status": "Tersedia",
            "kuota": 25,
            "terdaftar": 8,
            "materi": "SQL Advanced, Normalisasi Database",
            "syarat": "Nilai maksimal C, Kehadiran minimal 70%",
          },
          {
            "id": "RMD-003",
            "matakuliah": "Algoritma & Struktur Data",
            "dosen": "Agus Setiawan, M.Kom",
            "nilai_awal": "D",
            "tanggal_remidi": "2025-12-20",
            "waktu": "10:00 - 12:00",
            "ruangan": "Lab Komputer 2",
            "status": "Tersedia",
            "kuota": 20,
            "terdaftar": 18,
            "materi": "Sorting, Searching, Tree & Graph",
            "syarat": "Nilai minimal D, Kehadiran minimal 80%",
          },
        ];

        _remidiSaya = [
          {
            "id": "RMD-004",
            "matakuliah": "Pemrograman Web",
            "dosen": "Indra Saputra, M.T",
            "nilai_awal": "C",
            "tanggal_remidi": "2025-12-10",
            "waktu": "08:00 - 10:00",
            "ruangan": "Lab Komputer 3",
            "status": "Terdaftar",
            "nilai_remidi": null,
            "materi": "JavaScript ES6, React Basics",
            "catatan": "Pastikan membawa laptop dan sudah install Node.js",
          },
        ];

        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading remidi data: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      });
    }
  }

  // Daftar remidi
  Future<void> _daftarRemidi(Map<String, dynamic> remidi) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF4C7F9A)),
            SizedBox(width: 12),
            Text("Konfirmasi Pendaftaran"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apakah Anda yakin ingin mendaftar remidi untuk mata kuliah:",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4C7F9A).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    remidi["matakuliah"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Tanggal: ${remidi['tanggal_remidi']}"),
                  Text("Waktu: ${remidi['waktu']}"),
                  Text("Ruangan: ${remidi['ruangan']}"),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C7F9A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Daftar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Catatan: Implement API call untuk daftar remidi
      setState(() {
        _remidiSaya.add({
          ...remidi,
          "status": "Terdaftar",
          "nilai_remidi": null,
        });
        _remidiTersedia.remove(remidi);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Berhasil mendaftar remidi ${remidi['matakuliah']}",
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  // Batalkan remidi
  Future<void> _batalkanRemidi(Map<String, dynamic> remidi) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text("Konfirmasi Pembatalan"),
          ],
        ),
        content: Text(
          "Apakah Anda yakin ingin membatalkan pendaftaran remidi ${remidi['matakuliah']}?",
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Ya, Batalkan"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Catatan: Implement API call untuk batalkan remidi
      setState(() {
        _remidiSaya.remove(remidi);
        final newRemidi = Map<String, dynamic>.from(remidi);
        newRemidi["status"] = "Tersedia";
        newRemidi.remove("nilai_remidi");
        _remidiTersedia.add(newRemidi);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 12),
                Text("Pendaftaran remidi telah dibatalkan"),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Remidi Mahasiswa",
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
            Tab(text: "Remidi Tersedia"),
            Tab(text: "Remidi Saya"),
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
              children: [_buildRemidiTersediaTab(), _buildRemidiSayaTab()],
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
              onPressed: _loadRemidiData,
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

  Widget _buildRemidiTersediaTab() {
    return RefreshIndicator(
      onRefresh: _loadRemidiData,
      color: const Color(0xFF4C7F9A),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            const Text(
              "Daftar Remidi Tersedia",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            if (_remidiTersedia.isEmpty)
              _buildEmptyState("Tidak ada remidi yang tersedia saat ini.")
            else
              ..._remidiTersedia.map((item) => _buildRemidiTersediaCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildRemidiSayaTab() {
    return RefreshIndicator(
      onRefresh: _loadRemidiData,
      color: const Color(0xFF4C7F9A),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Remidi yang Saya Ikuti",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            if (_remidiSaya.isEmpty)
              _buildEmptyState("Anda belum mendaftar remidi apapun.")
            else
              ..._remidiSaya.map((item) => _buildRemidiSayaCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
            color: const Color(0xFF4C7F9A).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Informasi Remidi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Pastikan Anda memenuhi syarat sebelum mendaftar remidi",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemidiTersediaCard(Map<String, dynamic> item) {
    final isKuotaPenuh = item["terdaftar"] >= item["kuota"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
              color: const Color(0xFF4C7F9A).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["matakuliah"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["dosen"],
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isKuotaPenuh ? Colors.red : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Nilai: ${item['nilai_awal']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                _buildDetailRow(
                  Icons.calendar_today,
                  "Tanggal",
                  item["tanggal_remidi"],
                ),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.access_time, "Waktu", item["waktu"]),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.room, "Ruangan", item["ruangan"]),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  "Materi:",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item["materi"],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Text(
                  "Syarat:",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item["syarat"],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                // Kuota
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Kuota",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "${item['terdaftar']}/${item['kuota']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: item["terdaftar"] / item["kuota"],
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isKuotaPenuh
                                    ? Colors.red
                                    : const Color(0xFF4C7F9A),
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isKuotaPenuh ? null : () => _daftarRemidi(item),
                    icon: Icon(
                      isKuotaPenuh ? Icons.block : Icons.check_circle_outline,
                    ),
                    label: Text(
                      isKuotaPenuh ? "Kuota Penuh" : "Daftar Remidi",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isKuotaPenuh
                          ? Colors.grey
                          : const Color(0xFF4C7F9A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemidiSayaCard(Map<String, dynamic> item) {
    final hasNilai = item["nilai_remidi"] != null;
    final statusColor = hasNilai ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
              gradient: LinearGradient(
                colors: [
                  statusColor.withValues(alpha: 0.1),
                  statusColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["matakuliah"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["dosen"],
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hasNilai ? "Selesai" : "Terdaftar",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                      child: _buildInfoChip(
                        "Nilai Awal",
                        item["nilai_awal"],
                        Colors.red,
                      ),
                    ),
                    if (hasNilai) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoChip(
                          "Nilai Remidi",
                          item["nilai_remidi"],
                          Colors.green,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.calendar_today,
                  "Tanggal",
                  item["tanggal_remidi"],
                ),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.access_time, "Waktu", item["waktu"]),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.room, "Ruangan", item["ruangan"]),
                if (item["materi"] != null) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    "Materi:",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["materi"],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                if (item["catatan"] != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item["catatan"],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (!hasNilai) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _batalkanRemidi(item),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text(
                        "Batalkan Pendaftaran",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4C7F9A)),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
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
