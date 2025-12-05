import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        title: const Text(
          "NOTIFIKASI",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hari ini",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C7F9A),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildNotifTile("Tugas baru telah ditambahkan di Matkul Rangkaian Digital", "11.20"),
            _buildNotifTile("Tugas baru telah ditambahkan di Matkul Data Mining", "10.23"),
            const SizedBox(height: 20),
            const Text(
              "20 Sept",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C7F9A),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildNotifTile("Tugas baru telah ditambahkan di Matkul Technopreneurship", "13.40"),
            _buildNotifTile("Tugas baru telah ditambahkan di Matkul Mobile Programming", "19 Sept"),
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                "assets/images/notif.png", // ganti sesuai gambar kamu
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifTile(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_active_outlined, color: Color(0xFF4C7F9A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
