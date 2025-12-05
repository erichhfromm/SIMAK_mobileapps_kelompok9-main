import 'package:flutter/material.dart';

class KHSPage extends StatefulWidget {
  const KHSPage({super.key});

  @override
  State<KHSPage> createState() => _KHSPageState();
}

class _KHSPageState extends State<KHSPage> {
  int _currentView = 0; // 0: KRS, 1: Hasil Studi, 2: Detail KHS

  final Color _primaryColor = const Color(0xFF5B8FA3);
  final Color _backgroundColor = const Color(0xFFE8EEF2);

  // Dummy data KRS
  final List<Map<String, dynamic>> _krsDataGanjil = [
    {"kode": "IF203", "matkul": "Rekayasa Perangkat Lunak", "sks": 3},
    {"kode": "IF203", "matkul": "Sistem Digital", "sks": 3},
    {"kode": "IF204", "matkul": "Sistem Operasi", "sks": 3},
  ];

  final List<Map<String, dynamic>> _krsDataGenap = [
    {"kode": "", "matkul": "", "sks": 7},
    {"kode": "", "matkul": "", "sks": 7},
    {"kode": "", "matkul": "", "sks": 7},
  ];

  final List<Map<String, dynamic>> _krsDataSKS = [
    {"kode": "", "matkul": "", "sks": 4},
    {"kode": "", "matkul": "", "sks": 4},
    {"kode": "", "matkul": "", "sks": 4},
  ];

  // Dummy data Hasil Studi
  final List<Map<String, dynamic>> _hasilStudiData = [
    {
      "semester": "Tahun Akademik 2023/2024 Ganjil",
      "tanggal": "Tanggal: SKS diambil : 30",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2023/2024 Genap",
      "tanggal": "Tanggal: SKS diambil : 24",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2024/2025 Ganjil",
      "tanggal": "Tanggal: SKS diambil : 24",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2024/2025 Genap",
      "tanggal": "Tanggal: SKS diambil : 30",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2025/2026 Ganjil",
      "tanggal": "Tanggal: SKS diambil : 24",
      "status": "Status : Aktif",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(child: _buildCurrentView()),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 0:
        return _buildKRSView();
      case 1:
        return _buildHasilStudiView();
      case 2:
        return _buildDetailKHSView();
      default:
        return _buildKRSView();
    }
  }

  // View 1: Kartu Rencana Studi (KRS)
  Widget _buildKRSView() {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
            ),
          ),
        ),

        // Content
        Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kartu Rencana Studi (KRS)",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _currentView = 1),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "KARTU RENCANA",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "STUDI",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Semester 7",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Student Info
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: _primaryColor,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PANJALU GALIH AKBAR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "211552000000",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  "IPA / TEKNIK INFORMATIKA S.KOM, M.CS",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Three columns
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _buildKRSColumn(
                              "Mata Kuliah",
                              _krsDataGanjil,
                              true,
                            ),
                            const SizedBox(width: 8),
                            _buildKRSColumn("Semester", _krsDataGenap, false),
                            const SizedBox(width: 8),
                            _buildKRSColumn("SKS", _krsDataSKS, false),
                          ],
                        ),
                      ),
                    ),

                    // Total and buttons
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Total Dipilih : (24 SKS)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Klik ini jika ingin melihat kartu hasil studi",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKRSColumn(
    String title,
    List<Map<String, dynamic>> items,
    bool isMainColumn,
  ) {
    return Expanded(
      flex: isMainColumn ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isMainColumn
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item["kode"].isNotEmpty)
                                Text(
                                  item["kode"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (item["matkul"].isNotEmpty)
                                Text(
                                  item["matkul"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (item["sks"] != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${item['sks']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        : Center(
                            child: Text(
                              item["sks"] != null ? "${item['sks']}" : "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // View 2: Kartu Hasil Studi
  Widget _buildHasilStudiView() {
    return Stack(
      children: [
        // Background with decorative elements
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          top: 100,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -80,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),

        // Content
        Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => setState(() => _currentView = 0),
                  ),
                  const Expanded(
                    child: Text(
                      "Kartu Hasil Studi",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Profile photo with decorative elements
            Stack(
              alignment: Alignment.center,
              children: [
                // Decorative rings
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                // Profile photo
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: _primaryColor),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "KARTU HASIL STUDI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // List of hasil studi
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _hasilStudiData.length,
                itemBuilder: (context, index) {
                  final item = _hasilStudiData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.description,
                          color: _primaryColor,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        item["semester"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            item["tanggal"],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            item["status"],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => setState(() => _currentView = 2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // View 3: Detail KHS
  Widget _buildDetailKHSView() {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
            ),
          ),
        ),

        // Content
        Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => setState(() => _currentView = 1),
                  ),
                  const Expanded(
                    child: Text(
                      "Klik Detail Kartu Hasil Studi",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              "DETAIL KHS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // PDF Preview Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // PDF Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey[100],
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: _primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kartu Hasil Studi",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  Text(
                                    "Semester Ganjil 2023/2024",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // PDF Content Preview
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Simulated table header
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Mata Kuliah",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "SKS",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Nilai",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Simulated table rows
                              ...List.generate(
                                5,
                                (index) => Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                      right: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(fontSize: 9),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Mata Kuliah ${index + 1}",
                                          style: const TextStyle(fontSize: 9),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Text(
                                          "3",
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Text(
                                          "A",
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Download button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fitur unduh PDF akan segera hadir"),
                    ),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text(
                  "Unduh PDF",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile photo
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: _primaryColor),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}
