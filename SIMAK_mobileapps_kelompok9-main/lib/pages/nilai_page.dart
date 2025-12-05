import 'package:flutter/material.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  int _currentSemester = 1; // Default semester 1

  // Dummy data nilai per semester
  final Map<int, List<Map<String, dynamic>>> _nilaiPerSemester = {
    1: [
      {
        "matkul": "Mobile Programming",
        "dosen": "Muhammad Aziz Setiaji Leksono, M.kom",
        "nilai": "A",
        "status": "Lulus",
        "sks": 4,
      },
      {
        "matkul": "Rangkaian Digital",
        "dosen": "Deni Satria, M.kom",
        "nilai": "A",
        "status": "Lulus",
        "sks": 3,
      },
      {
        "matkul": "Bahasa Indonesia",
        "dosen": "Nugraheni Tuffin, M.Pd",
        "nilai": "C",
        "status": "Normal",
        "sks": 2,
      },
      {
        "matkul": "Technopreneurship",
        "dosen": "Deni Tuffin, M.Pd",
        "nilai": "A",
        "status": "Lulus",
        "sks": 2,
      },
      {
        "matkul": "Pancasila",
        "dosen": "Olivia Azzahra, M.Pd",
        "nilai": "A",
        "status": "Lulus",
        "sks": 2,
      },
    ],
    2: [
      {
        "matkul": "Pemrograman Web",
        "dosen": "Rina Kusuma, M.T",
        "nilai": "A",
        "status": "Lulus",
        "sks": 3,
      },
      {
        "matkul": "Sistem Operasi",
        "dosen": "Ahmad Fauzi, M.Kom",
        "nilai": "B+",
        "status": "Lulus",
        "sks": 3,
      },
      {
        "matkul": "Jaringan Komputer",
        "dosen": "Dewi Sartika, M.T",
        "nilai": "A-",
        "status": "Lulus",
        "sks": 3,
      },
    ],
  };

  final Color _primaryColor = const Color(0xFF4C7F9A);
  final Color _backgroundColor = const Color(0xFFF5F7FA);

  Color _getStatusColor(String status) {
    return status == "Lulus" ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final currentNilai = _nilaiPerSemester[_currentSemester] ?? [];

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Back button and title
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "NILAI\nUJIAN AKHIR SEMESTER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                  ),

                  // Semester navigation
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          onPressed: _currentSemester > 1
                              ? () => setState(() => _currentSemester--)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Semester Ganjil 2023/2024",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          onPressed: _currentSemester < _nilaiPerSemester.length
                              ? () => setState(() => _currentSemester++)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // List of grades
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: currentNilai.length,
                itemBuilder: (context, index) {
                  final item = currentNilai[index];
                  return _buildNilaiCard(
                    matkul: item["matkul"],
                    dosen: item["dosen"],
                    nilai: item["nilai"],
                    status: item["status"],
                  );
                },
              ),
            ),

            // Profile photo at bottom
            Padding(
              padding: const EdgeInsets.all(20),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: _primaryColor,
                child: const Icon(Icons.person, size: 35, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Latest Nilai Transkrip",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNilaiCard({
    required String matkul,
    required String dosen,
    required String nilai,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Course info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matkul,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dosen,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right side - Grade and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Grade
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  nilai,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
