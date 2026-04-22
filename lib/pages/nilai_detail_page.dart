import 'package:flutter/material.dart';

class NilaiDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const NilaiDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        title: Text("${data['matkul']}"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row("Mata Kuliah", data["matkul"]),
              _row("Kode", data["kode"]),
              _row("Semester", data["semester"]),
              _row("SKS", "${data["sks"]}"),
              const Divider(height: 24),
              _row("Nilai Akhir", data["nilai"], bold: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
