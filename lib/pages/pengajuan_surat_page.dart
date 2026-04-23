import 'package:flutter/material.dart';

class PengajuanSuratPage extends StatefulWidget {
  const PengajuanSuratPage({super.key});

  @override
  State<PengajuanSuratPage> createState() => _PengajuanSuratPageState();
}

class _PengajuanSuratPageState extends State<PengajuanSuratPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedJenisSurat;
  final TextEditingController _keteranganController = TextEditingController();

  final List<String> _jenisSuratOptions = [
    "Surat Keterangan Aktif Kuliah",
    "Surat Cuti Akademik",
    "Surat Izin Penelitian",
    "Surat Pengantar Magang",
    "Transkrip Nilai Sementara",
  ];

  // Data Dummy Riwayat Pengajuan
  final List<Map<String, String>> _riwayatPengajuan = [
    {
      "jenis": "Surat Keterangan Aktif Kuliah",
      "tanggal": "01 Des 2025",
      "status": "Selesai",
    },
    {
      "jenis": "Surat Izin Penelitian",
      "tanggal": "25 Nov 2025",
      "status": "Proses",
    },
  ];

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  void _submitPengajuan() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _riwayatPengajuan.insert(0, {
          "jenis": _selectedJenisSurat!,
          "tanggal": "Hari ini",
          "status": "Proses",
        });
        _keteranganController.clear();
        _selectedJenisSurat = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permohonan berhasil diajukan"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE), // Sama dengan tema surat
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Pengajuan Surat",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Form Pengajuan Baru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C7F9A),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown Jenis Surat
                    DropdownButtonFormField<String>(
                      initialValue: _selectedJenisSurat,
                      decoration: InputDecoration(
                        labelText: "Jenis Surat",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: _jenisSuratOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedJenisSurat = val),
                      validator: (val) =>
                          val == null ? 'Pilih jenis surat' : null,
                    ),
                    const SizedBox(height: 16),

                    // Keterangan Field
                    TextFormField(
                      controller: _keteranganController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Keterangan / Keperluan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Isi keterangan' : null,
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitPengajuan,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text("Ajukan Permohonan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C7F9A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Riwayat Pengajuan Saya",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C7F9A),
              ),
            ),
            const SizedBox(height: 12),

            // List Riwayat
            if (_riwayatPengajuan.isEmpty)
              const Center(
                child: Text(
                  "Belum ada pengajuan",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ..._riwayatPengajuan.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: item["status"] == "Selesai"
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item["status"] == "Selesai"
                              ? Icons.check_circle
                              : Icons.access_time_filled,
                          color: item["status"] == "Selesai"
                              ? Colors.green
                              : Colors.orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["jenis"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["tanggal"]!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item["status"] == "Selesai"
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item["status"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
