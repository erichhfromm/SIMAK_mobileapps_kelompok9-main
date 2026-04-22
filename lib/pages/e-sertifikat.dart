import 'package:flutter/material.dart';

class ESertifikatPage extends StatefulWidget {
  const ESertifikatPage({super.key});

  @override
  State<ESertifikatPage> createState() => _ESertifikatPageState();
}

class _ESertifikatPageState extends State<ESertifikatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data Dummy Sertifikat Mahasiswa
  final List<Map<String, dynamic>> _allCertificates = [
    {
      "title": "Juara 1 Hackathon 2024",
      "category": "Lomba",
      "date": "15 Nov 2024",
      "organizer": "Fakultas Ilmu Komputer",
      "status": "Verified",
      "file": "cert_hackathon_2024.pdf"
    },
    {
      "title": "Peserta Seminar Nasional AI",
      "category": "Seminar",
      "date": "20 Okt 2024",
      "organizer": "Himpunan Mahasiswa TI",
      "status": "Verified",
      "file": "cert_seminar_ai.pdf"
    },
    {
      "title": "Workshop Flutter Development",
      "category": "Workshop",
      "date": "05 Okt 2024",
      "organizer": "Google Developer Student Clubs",
      "status": "Verified",
      "file": "cert_workshop_flutter.pdf"
    },
    {
      "title": "Panitia Dies Natalis ke-40",
      "category": "Organisasi",
      "date": "10 Sep 2024",
      "organizer": "Universitas SWU",
      "status": "Verified",
      "file": "cert_panitia_dies.pdf"
    },
    {
      "title": "TOEFL Preparation Course",
      "category": "Workshop",
      "date": "12 Agu 2024",
      "organizer": "Pusat Bahasa",
      "status": "Verified",
      "file": "cert_toefl_prep.pdf"
    },
  ];

  List<Map<String, dynamic>> _filteredCertificates = [];
  String _selectedCategory = "Semua";

  @override
  void initState() {
    super.initState();
    _filteredCertificates = _allCertificates;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final categories = ["Semua", "Seminar", "Workshop", "Lomba"];
      setState(() {
        _selectedCategory = categories[_tabController.index];
        _filterCertificates();
      });
    }
  }

  void _filterCertificates() {
    if (_selectedCategory == "Semua") {
      _filteredCertificates = _allCertificates;
    } else {
      _filteredCertificates = _allCertificates
          .where((cert) => cert["category"] == _selectedCategory || (cert["category"] == "Organisasi" && _selectedCategory == "Lomba")) // Simplifikasi mapping
          .toList();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background
      appBar: AppBar(
        title: const Text(
          'E-Sertifikat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C7F9A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Semua"),
            Tab(text: "Seminar"),
            Tab(text: "Workshop"),
            Tab(text: "Lomba"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4C7F9A),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                 BoxShadow(
                  color: const Color(0xFF4C7F9A).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Arsip Prestasi & Kegiatan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Unduh sertifikat kegiatan akademik dan non-akademik Anda di sini.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // List Sertifikat
          Expanded(
            child: _filteredCertificates.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCertificates.length,
                    itemBuilder: (context, index) {
                      final cert = _filteredCertificates[index];
                      return _buildCertificateCard(cert);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Belum ada sertifikat di kategori ini",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCertificateDetail(cert),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _CategoryColor(cert["category"]).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _CategoryIcon(cert["category"]),
                    color: _CategoryColor(cert["category"]),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          cert["category"],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cert["title"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert["date"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Valid Badge
                const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helpers untuk UI dinamis berdasarkan kategori
  Color _CategoryColor(String category) {
    switch (category) {
      case "Lomba": return Colors.orange;
      case "Seminar": return Colors.purple;
      case "Workshop": return Colors.blue;
      case "Organisasi": return Colors.teal;
      default: return Colors.blueGrey;
    }
  }

  IconData _CategoryIcon(String category) {
    switch (category) {
      case "Lomba": return Colors.orange is Color ? Icons.emoji_events_outlined : Icons.star;
      case "Seminar": return Icons.mic_external_on_outlined;
      case "Workshop": return Icons.build_circle_outlined;
      case "Organisasi": return Icons.groups_outlined; 
      default: return Icons.article_outlined;
    }
  }

  void _showCertificateDetail(Map<String, dynamic> cert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              _CategoryIcon(cert["category"]),
              size: 64,
              color: _CategoryColor(cert["category"]),
            ),
            const SizedBox(height: 16),
            Text(
              cert["title"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Penyelenggara: ${cert['organizer']}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
             const SizedBox(height: 4),
             Text(
              "Tanggal: ${cert['date']}",
               style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.share_outlined),
                    label: const Text("Bagikan"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                       Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text("Mengunduh sertifikat..."), backgroundColor: Color(0xFF4C7F9A)),
                       );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text("Unduh PDF"),
                     style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C7F9A), // Theme color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}