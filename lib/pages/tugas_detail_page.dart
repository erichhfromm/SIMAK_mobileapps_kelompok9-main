import 'package:flutter/material.dart';

class TugasDetailPage extends StatelessWidget {
  final String matkul;
  final String judul;
  final String deadline;

  const TugasDetailPage({
    super.key,
    required this.matkul,
    required this.judul,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
  backgroundColor: const Color(0xFF4C7F9A),
  centerTitle: true, //text di tengah
  title: const Text(
    "Detail Tugas",
    style: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C7F9A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Mata Kuliah: $matkul",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Deadline: $deadline",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Preview PDF Tugas (Dummy)",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C7F9A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Kembali", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
