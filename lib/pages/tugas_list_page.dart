import 'package:flutter/material.dart';
import 'tugas_detail_page.dart';

class TugasListPage extends StatelessWidget {
  const TugasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list tugas — nanti bisa diambil dari API
    final List<Map<String, String>> tugas = [
      {
        "matkul": "Mobile Programming",
        "judul": "Tugas Membuat Layout Login",
        "deadline": "12 Jan 2025",
      },
      {
        "matkul": "Data Mining",
        "judul": "Tugas Preprocessing Dataset",
        "deadline": "18 Jan 2025",
      },
      {
        "matkul": "Sistem Basis Data",
        "judul": "Rancang ERD Database",
        "deadline": "20 Jan 2025",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        elevation: 2,
        title: const Text(
          "Daftar Tugasku",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tugas.length,
        itemBuilder: (context, index) {
          final item = tugas[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4C7F9A).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF4C7F9A),
                ),
              ),
              title: Text(
                item["judul"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item["matkul"]!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Color(0xFF4C7F9A),
                  ),
                  Text(
                    item["deadline"]!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4C7F9A),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TugasDetailPage(
                      matkul: item["matkul"]!,
                      judul: item["judul"]!,
                      deadline: item["deadline"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
