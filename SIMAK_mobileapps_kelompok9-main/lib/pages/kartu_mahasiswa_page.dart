import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class KartuMahasiswaPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const KartuMahasiswaPage({super.key, required this.user});

  String _extractProdi(Map<String, dynamic> user) {
    // Cek beberapa kemungkinan struktur key untuk program studi
    final dynamic p1 = user['program_studi'];
    final dynamic p2 = user['prodi'];
    final dynamic p3 = user['nama_prodi'];
    // Jika program_studi adalah map, ambil nama_prodi / nama
    if (p1 != null) {
      if (p1 is Map) {
        return (p1['nama_prodi'] ?? p1['nama'] ?? p1['nama_prodi'.toString()])?.toString() ?? 'Program Studi Tidak Diketahui';
      } else {
        return p1.toString();
      }
    }
    if (p2 != null) return p2.toString();
    if (p3 != null) return p3.toString();
    return 'Program Studi Tidak Diketahui';
  }

  Future<void> _cetakKartu(BuildContext context) async {
    final fotoUrl = user['foto'];
    final nama = user['nama'] ?? '-';
    final nim = user['nim'] ?? '-';
    final prodi = _extractProdi(user);

    final pdf = pw.Document();

    // ambil gambar (network atau asset fallback)
    final netImage = (fotoUrl != null && fotoUrl.toString().isNotEmpty)
        ? await networkImage(fotoUrl)
        : await imageFromAssetBundle('assets/images/default_user.png');

    // buat QR sebagai image data
    final qrImage = await QrPainter(
      data: "https://kampusku.ac.id/mahasiswa/$nim",
      version: QrVersions.auto,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
    ).toImageData(200);

    final qrPwImage = pw.MemoryImage(qrImage!.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 350,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(16),
                boxShadow: [
                  pw.BoxShadow(
                    color: PdfColors.grey300,
                    blurRadius: 4,
                    offset: const PdfPoint(2, 2),
                  )
                ],
                border: pw.Border.all(color: PdfColors.blueGrey, width: 1),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    "KARTU MAHASISWA",
                    style: pw.TextStyle(
                      color: PdfColors.blue800,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // FOTO
                  pw.ClipRRect(
                    horizontalRadius: 8,
                    verticalRadius: 8,
                    child: pw.Image(netImage, width: 200, fit: pw.BoxFit.contain),
                  ),

                  pw.SizedBox(height: 10),
                  pw.Text(prodi,
                      style: const pw.TextStyle(color: PdfColors.black, fontSize: 12)),
                  pw.SizedBox(height: 10),

                  // NAMA & NIM + QR
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF4C7F9A),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(qrPwImage, width: 60, height: 60),
                        pw.SizedBox(width: 12),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              nama,
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              nim,
                              style: pw.TextStyle(
                                color: PdfColors.grey100,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Kartu_Mahasiswa_$nim.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final fotoUrl = user['foto'];
    final nama = user['nama'] ?? '-';
    final nim = user['nim'] ?? '-';
    final prodi = _extractProdi(user);

    return Scaffold(
      backgroundColor: const Color(0xFFE3EDF2),
      appBar: AppBar(
        title: const Text(
          "Kartu Mahasiswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded, color: Colors.white, size: 26),
            tooltip: "Cetak / Unduh PDF",
            onPressed: () => _cetakKartu(context),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "KARTU MAHASISWA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF4C7F9A),
                ),
              ),
              const SizedBox(height: 10),

              // ==== FOTO PROFIL ====
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                    maxHeight: 200,
                  ),
                  color: Colors.grey.shade200,
                  child: (fotoUrl != null && fotoUrl != "")
                      ? Image.network(
                          fotoUrl,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          "assets/images/default_user.png",
                          fit: BoxFit.contain,
                        ),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                prodi,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 12),

              // ==== NAMA & NIM + QR DINAMIS ====
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4C7F9A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: "https://kampusku.ac.id/mahasiswa/$nim",
                      version: QrVersions.auto,
                      size: 70,
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4C7F9A),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          nim,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
