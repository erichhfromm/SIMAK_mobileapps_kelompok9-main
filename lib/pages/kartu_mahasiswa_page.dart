import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class KartuMahasiswaPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const KartuMahasiswaPage({super.key, required this.user});

  @override
  State<KartuMahasiswaPage> createState() => _KartuMahasiswaPageState();
}

class _KartuMahasiswaPageState extends State<KartuMahasiswaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  String _extractProdi(Map<String, dynamic> user) {
    final dynamic p1 = user['program_studi'];
    final dynamic p2 = user['prodi'];
    if (p1 != null) {
      if (p1 is Map) {
        return (p1['nama_prodi'] ?? p1['nama'])?.toString() ?? '-';
      }
      return p1.toString();
    }
    return p2?.toString() ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    final fotoUrl = widget.user['foto'];
    final nama = widget.user['nama'] ?? 'Mahasiswa';
    final nim = widget.user['nim'] ?? '-';
    final prodi = _extractProdi(widget.user);

    // QR Data: JSON String containing logic to "show" student info (simulated)
    final qrData = "ID:$nim;NAMA:$nama;PRODI:$prodi;VALID:TRUE";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Digital Student ID", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: "Cetak Kartu",
            onPressed: () => _cetakKartu(context, qrData),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ketuk kartu untuk membalik",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Rotation logic
                  final angle = _animation.value * pi;
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateY(angle);

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: _animation.value < 0.5
                        ? _buildFrontCard(nama, nim, prodi, fotoUrl)
                        : Transform(
                            transform: Matrix4.identity()..rotateY(pi),
                            alignment: Alignment.center,
                            child: _buildBackCard(qrData),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(
      String nama, String nim, String prodi, String? fotoUrl) {
    return Container(
      width: 340,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4C7F9A), Color(0xFF2C5F7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
        image: const DecorationImage(
           image: AssetImage("assets/images/logo_swu.png"), // Watermark
           opacity: 0.1,
           fit: BoxFit.contain,
           alignment: Alignment.centerRight,
        )
      ),
      child: Stack(
        children: [
          // Pattern Overlay (Optional)
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // FOTO
                Container(
                  width: 90,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: (fotoUrl != null && fotoUrl.isNotEmpty)
                          ? NetworkImage(fotoUrl)
                          : const AssetImage("assets/images/default_user.png")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // DATA text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         decoration: BoxDecoration(
                           color: Colors.white24,
                           borderRadius: BorderRadius.circular(8),
                         ),
                         child: const Text("MAHASISWA", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold))
                       ),
                       const SizedBox(height: 12),
                       Text(
                        nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        nim,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 1.2,
                          fontFamily: "Monospace",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prodi,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Bottom Bar
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 const Text("Universitas SWU", style: TextStyle(color: Colors.white54, fontSize: 10)),
                 // Chip Active
                 Container(
                   width: 30,
                   height: 20,
                   decoration: BoxDecoration(
                     color: Colors.amber.shade300,
                     borderRadius: BorderRadius.circular(4),
                     gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFB300)])
                   ),
                 )
               ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBackCard(String qrData) {
    return Container(
      width: 340,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
           // Decoration Lines
           Positioned(top: 0, left: 0, right: 0, child: Container(height: 10, decoration: const BoxDecoration(color: Color(0xFF4C7F9A), borderRadius: BorderRadius.vertical(top: Radius.circular(20))))),

           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text(
                 "PINDIG DIGITAL ID",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 2,
                  ),
               ),
               const SizedBox(height: 20),
               QrImageView(
                 data: qrData,
                 version: QrVersions.auto,
                 size: 100,
                 backgroundColor: Colors.white,
               ),
               const SizedBox(height: 16),
               const Text(
                 "Scan untuk verifikasi data",
                 style: TextStyle(color: Colors.grey, fontSize: 10),
               ),
             ],
           ),
        ],
      ),
    );
  }

  // ==== PDF PRINT LOGIC (UNCHANGED BUT ADAPTED) ====
  Future<void> _cetakKartu(BuildContext context, String qrData) async {
    final pdf = pw.Document();
    
    // Fallback Image handling
    pw.ImageProvider? netImage;
    try {
      final url = widget.user['foto'];
      if (url != null && url.toString().isNotEmpty) {
        netImage = await networkImage(url);
      }
    } catch (_) {}
    
    // QR Generation for PDF
    final qrImage = await QrPainter(
      data: qrData,
      version: QrVersions.auto,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
    ).toImageData(200);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(85.6 * PdfPageFormat.mm, 53.98 * PdfPageFormat.mm),
        build: (context) {
          return pw.Center(
            child: pw.Container(
              width: 300,
              height: 190,
              decoration: pw.BoxDecoration(
                 color: PdfColors.white,
                 border: pw.Border.all(),
                 borderRadius: pw.BorderRadius.circular(10)
              ),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 100,
                    color: PdfColor.fromInt(0xFF4C7F9A),
                    child: pw.Center(
                       child: netImage != null 
                         ? pw.Image(netImage, width: 80, height: 100, fit: pw.BoxFit.cover)
                         : pw.Container(color: PdfColors.grey300, width: 80, height: 100)
                    )
                  ),
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("KARTU MAHASISWA", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.blueGrey)),
                          pw.SizedBox(height: 5),
                          pw.Text(widget.user['nama'] ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                          pw.Text(widget.user['nim'] ?? '-', style: const pw.TextStyle(fontSize: 10)),
                          pw.SizedBox(height: 10),
                          if (qrImage != null)
                            pw.Image(pw.MemoryImage(qrImage.buffer.asUint8List()), width: 40, height: 40)
                        ]
                      )
                    )
                  )
                ]
              )
            )
          );
        }
      )
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'KTM_${widget.user['nim']}.pdf',
    );
  }
}
