import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


/// ==============================================
/// 📩 Surat Kotak Masuk Page — Final Generate PDF
/// ==============================================
class SuratKotakMasukPage extends StatefulWidget {
  const SuratKotakMasukPage({super.key});

  @override
  State<SuratKotakMasukPage> createState() => _SuratKotakMasukPageState();
}

class _SuratKotakMasukPageState extends State<SuratKotakMasukPage> {
  int? hoveredIndex;

  final suratList = [
    {
      "title": "Bagian Administrasi Akademik",
      "perihal": "Perihal: Pengambilan Surat Keterangan Aktif Kuliah",
      "isi":
          "Dengan hormat,\nBersama ini kami informasikan bahwa surat keterangan yang telah Anda ajukan melalui sistem informasi akademik telah selesai diproses.\nSilakan mengambil dokumen tersebut di bagian administrasi pada jam kerja.",
      "waktu": "10.20",
    },
    {
      "title": "Bagian Administrasi Akademik",
      "perihal": "Perihal: Persetujuan Surat Cuti Akademik",
      "isi":
          "Halo Ahya Nurjanna,\nPermohonan Cuti Akademik Semester Ganjil 2025/2026 telah disetujui oleh pihak Universitas.\nKami lampirkan Surat Cuti Akademik dalam format PDF sebagai arsip pribadi.",
      "waktu": "14.20",
    },
    {
      "title": "Bagian Akademik dan Kemahasiswaan",
      "perihal": "Perihal: Surat Izin Penelitian",
      "isi":
          "Kepada Yth. Ahya Nurjanna,\nSurat Izin Penelitian yang Anda ajukan telah disetujui oleh Fakultas.\nDokumen ini dapat digunakan untuk keperluan pengambilan data di instansi terkait.",
      "waktu": "09.45",
    },
    {
      "title": "Bagian Kemahasiswaan",
      "perihal": "Perihal: Surat Pengantar Magang",
      "isi":
          "Dengan hormat,\nSurat Pengantar Magang Anda telah diterbitkan dan dapat digunakan untuk melaksanakan kegiatan magang di instansi tujuan.\nHarap melaporkan hasil kegiatan magang setelah selesai.",
      "waktu": "08.30",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // panah putih
        title: const Text(
          "SURAT",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.5, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C7F9A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "KOTAK MASUK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/logo_swu.png',
                  height: 38,
                ),
              ],
            ),
            const SizedBox(height: 18),

            // daftar surat
            for (int i = 0; i < suratList.length; i++) ...[
              MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = i),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  transform: hoveredIndex == i
                      ? (Matrix4.identity()..translate(0.0, -4.0, 0.0))
                      : Matrix4.identity(),
                  curve: Curves.easeOut,
                  child: suratCard(
                    context,
                    title: suratList[i]["title"]!,
                    perihal: suratList[i]["perihal"]!,
                    isi: suratList[i]["isi"]!,
                    waktu: suratList[i]["waktu"]!,
                    elevated: hoveredIndex == i,
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget suratCard(
    BuildContext context, {
    required String title,
    required String perihal,
    required String isi,
    required String waktu,
    bool elevated = false,
  }) {
    return GestureDetector(
      onTap: () => _showDetail(context, title, perihal, isi, waktu),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0x4DD6F1FF), // D6F1FF 30% opacity
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: elevated
                  ? Colors.black26.withOpacity(0.25)
                  : Colors.black12.withOpacity(0.12),
              blurRadius: elevated ? 20 : 10,
              offset: elevated ? const Offset(0, 8) : const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 8),
                Text(perihal,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black87)),
                const SizedBox(height: 10),
                Text(
                  isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.4, color: Colors.black87),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Text(waktu,
                  style:
                      const TextStyle(color: Colors.black45, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, String title, String perihal,
      String isi, String waktu) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Detail Surat",
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: suratDetail(title, perihal, isi, waktu),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );
  }

  Widget suratDetail(String title, String perihal, String isi, String waktu) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C7F9A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "KOTAK MASUK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            Text(perihal,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            Text(waktu,
                style: const TextStyle(color: Colors.black45, fontSize: 12)),
            const SizedBox(height: 20),
            Text(isi,
                style: const TextStyle(
                    height: 1.55, fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () async =>
                    await _generateSuratPdf(context, title, perihal, isi, waktu),
                icon: const Icon(Icons.download_rounded),
                label: const Text("surat.pdf"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C7F9A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(140, 44),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   /// 🧾 Generate dan langsung simpan PDF surat yang diklik
  Future<void> _generateSuratPdf(
      BuildContext context, String title, String perihal, String isi, String waktu) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'UNIVERSITAS SWU',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.blue800,
                  font: pw.Font.helveticaBold(),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 18),
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 15,
                  font: pw.Font.helveticaBold(),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                perihal,
                style: pw.TextStyle(
                  fontSize: 13,
                  font: pw.Font.helveticaBold(),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                "Waktu: $waktu",
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                isi,
                style: const pw.TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Tim Akademik SWU",
                  style: pw.TextStyle(
                    fontSize: 13,
                    font: pw.Font.helveticaBold(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: "${perihal.replaceAll(' ', '_')}.pdf",
    );
  }
}
