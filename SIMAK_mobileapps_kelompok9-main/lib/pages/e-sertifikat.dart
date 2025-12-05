import 'package:flutter/material.dart';

class ESertifikatPage extends StatelessWidget {
  const ESertifikatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Sertifikat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar E-Sertifikat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // LIST DATA SERTIFIKAT
            Expanded(
              child: ListView(
                children: [
                  _sertifikatItem(
                    context,
                    nama: 'Sertifikat Pelatihan Zakat',
                    tanggal: '10 Nov 2024',
                    file: 'sertifikat_zakat.pdf',
                  ),
                  _sertifikatItem(
                    context,
                    nama: 'Sertifikat Webinar Amil',
                    tanggal: '21 Okt 2024',
                    file: 'webinar_amil.pdf',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sertifikatItem(BuildContext context, {
    required String nama,
    required String tanggal,
    required String file,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(nama),
        subtitle: Text('Diterbitkan: $tanggal'),
        trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
        onTap: () {
          // TODO: buka file pdf
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Membuka $file...')),
          );
        },
      ),
    );
  }
}