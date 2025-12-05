import 'package:flutter/material.dart';

class TranskripPage extends StatelessWidget {
  const TranskripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyCourses = [
      {"matkul": "MOBILE PROGRAMMING", "sks": 4, "nilai": "A"},
      {"matkul": "Data Mining", "sks": 3, "nilai": "B"},
      {"matkul": "Agama", "sks": 2, "nilai": "B"},
      {"matkul": "Pancasila", "sks": 2, "nilai": "B"},
      {"matkul": "Rangkaian Digital", "sks": 3, "nilai": "C"},
      {"matkul": "Bahasa Indonesia", "sks": 3, "nilai": "A"},
      {"matkul": "Kewarganegaraan", "sks": 2, "nilai": "A"},
      {"matkul": "Etika Profesi & B.Inggri", "sks": 3, "nilai": "A"},
      {"matkul": "Sistem Informasi", "sks": 2, "nilai": "A"},
      {"matkul": "Manajemen Bisnis", "sks": 2, "nilai": "B"},
    ];

    // Calculate total SKS
    int totalSKS = dummyCourses.fold(
      0,
      (sum, item) => sum + (item["sks"] as int),
    );
    double ipk = 2.85;

    final Color primaryColor = const Color(0xFF4C7F9A);
    final Color backgroundColor = const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "NILAI TRANSKRIP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // List of courses
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: dummyCourses.length,
                itemBuilder: (context, index) {
                  final item = dummyCourses[index];
                  return _buildTranskripCard(
                    matkul: item["matkul"],
                    sks: item["sks"],
                    nilai: item["nilai"],
                    primaryColor: primaryColor,
                  );
                },
              ),
            ),

            // Summary section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total SKS",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        "$totalSKS",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "IPK Semester",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        ipk.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Fitur cetak akan segera hadir"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE74C3C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Cetak",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Fitur kirim akan segera hadir"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Kirimkan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTranskripCard({
    required String matkul,
    required int sks,
    required String nilai,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course name
          Expanded(
            child: Text(
              matkul,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // SKS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$sks",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Grade
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              nilai,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
