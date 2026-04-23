import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class KHSPage extends StatefulWidget {
  const KHSPage({super.key});

  @override
  State<KHSPage> createState() => _KHSPageState();
}

class _KHSPageState extends State<KHSPage> {
  int _currentView =
      1; // 0: KRS, 1: Hasil Studi, 2: Detail KHS (default to Hasil Studi)
  int _selectedSemesterIndex = 0;

  final Color _primaryColor = const Color(0xFF5B8FA3);
  final Color _backgroundColor = const Color(0xFFE8EEF2);

  // Dummy data KRS
  final List<Map<String, dynamic>> _krsDataGanjil = [
    {"kode": "IF203", "matkul": "Rekayasa Perangkat Lunak", "sks": 3},
    {"kode": "IF203", "matkul": "Sistem Digital", "sks": 3},
    {"kode": "IF204", "matkul": "Sistem Operasi", "sks": 3},
  ];

  final List<Map<String, dynamic>> _krsDataGenap = [
    {"kode": "", "matkul": "", "sks": 7},
    {"kode": "", "matkul": "", "sks": 7},
    {"kode": "", "matkul": "", "sks": 7},
  ];

  final List<Map<String, dynamic>> _krsDataSKS = [
    {"kode": "", "matkul": "", "sks": 4},
    {"kode": "", "matkul": "", "sks": 4},
    {"kode": "", "matkul": "", "sks": 4},
  ];

  // Dummy data Hasil Studi
  final List<Map<String, dynamic>> _hasilStudiData = [
    {
      "semester": "Tahun Akademik 2023/2024 Ganjil",
      "tanggal": "Tanggal: SKS diambil : 30",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2023/2024 Genap",
      "tanggal": "Tanggal: SKS diambil : 24",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2024/2025 Ganjil",
      "tanggal": "Tanggal: SKS diambil : 24",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2024/2025 Genap",
      "tanggal": "Tanggal: SKS diambil : 30",
      "status": "Status : Aktif",
    },
    {
      "semester": "Tahun Akademik 2025/2026 Ganjil",
      "tanggal": "Tanggal: SKS diambil : 24",
      "status": "Status : Aktif",
    },
  ];

  Future<void> _generatePDF(Map<String, dynamic> semesterData) async {
    final pdf = pw.Document();

    // Calculate GPA (IPS) - Dummy calculation based on dummy data
    double totalSks = 0;
    double totalPoints = 0;

    // Using _krsDataGanjil as dummy data for the selected semester's courses
    // In a real app, you would fetch courses for the specific semester
    final courses = _krsDataGanjil;

    for (var course in courses) {
      double sks = (course['sks'] as int).toDouble();
      totalSks += sks;
      totalPoints += sks * 4.0; // Assuming all A's (4.0) for this example
    }

    double ips = totalSks > 0 ? totalPoints / totalSks : 0.0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'KARTU HASIL STUDI (KHS)',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Universitas - Sistem Informasi Akademik',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                pw.PdfLogo(),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text('Nama: Panjalu Galih Akbar'),
                    pw.Spacer(),
                    pw.Text('NIM: 211552000000'),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Text('Program Studi: Teknik Informatika'),
                pw.Text('Semester: ${semesterData['semester']}'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            context: context,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            headerHeight: 25,
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
            },
            headers: ['Kode', 'Mata Kuliah', 'SKS', 'Nilai', 'Mutu'],
            data: courses.map((course) {
              return [
                course['kode'],
                course['matkul'],
                course['sks'].toString(),
                'A', // Dummy grade
                (course['sks'] * 4).toString(), // Dummy points
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Total SKS: ${totalSks.toStringAsFixed(0)}'),
                  pw.Text(
                    'Indeks Prestasi Semester (IPS): ${ips.toStringAsFixed(2)}',
                  ),
                  pw.Text('Indeks Prestasi Kumulatif (IPK): 3.85'), // Dummy IPK
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 50),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('Mengetahui,'),
                  pw.SizedBox(height: 50),
                  pw.Text('Ketua Program Studi'),
                  pw.SizedBox(height: 5),
                  pw.Text('( ....................... )'),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    // Generate the PDF bytes
    final bytes = await pdf.save();
    final fileName =
        'KHS_${semesterData['semester'].toString().replaceAll('/', '_').replaceAll(' ', '_')}.pdf';

    // Handle Web Platform
    if (kIsWeb) {
      await Printing.sharePdf(bytes: bytes, filename: fileName);
      return;
    }

    // Handle Mobile Platform (Android/iOS)
    // We wrap this in a try-catch and specific check to be safe
    try {
      Directory? directory;
      String folderName = 'Download';

      if (Platform.isAndroid) {
        // Try multiple paths for Android
        final List<String> possiblePaths = [
          '/storage/emulated/0/Download',
          '/storage/emulated/0/Downloads',
        ];

        bool foundPath = false;
        for (String path in possiblePaths) {
          try {
            directory = Directory(path);
            if (await directory.exists()) {
              foundPath = true;
              break;
            }
          } catch (_) {}
        }

        // Fallback to app-specific external storage
        if (!foundPath) {
          try {
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              directory = Directory('${externalDir.path}/Downloads');
              if (!await directory.exists()) {
                await directory.create(recursive: true);
              }
              folderName = directory.path;
            }
          } catch (_) {}
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
        folderName = directory.path;
      }

      // Final fallback
      directory ??= await getApplicationDocumentsDirectory();

      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF Berhasil disimpan di folder $folderName'),
            backgroundColor: _primaryColor,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'BUKA',
              textColor: Colors.white,
              onPressed: () {
                OpenFile.open(file.path);
              },
            ),
          ),
        );
      }

      // Try to open it immediately
      await OpenFile.open(file.path);
    } catch (e) {
      // If direct file saving fails (e.g. permissions), fallback to Share/Print dialog
      if (mounted) {
        // Show error but try to share/print it as backup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mencoba metode alternatif...')),
        );
      }
      await Printing.sharePdf(bytes: bytes, filename: fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(child: _buildCurrentView()),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 0:
        return _buildKRSView();
      case 1:
        return _buildHasilStudiView();
      case 2:
        return _buildDetailKHSView();
      default:
        return _buildKRSView();
    }
  }

  // View 1: Kartu Rencana Studi (KRS)
  Widget _buildKRSView() {
    return Stack(
      children: [
        // Persistent back button top-left to return to dashboard
        Positioned(
          top: 8,
          left: 8,
          child: SafeArea(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                splashRadius: 20,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const BottomNav()),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ),
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)],
            ),
          ),
        ),

        // Content
        Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        tooltip: 'Kembali ke Dashboard',
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/main',
                          (route) => false,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Kartu Rencana Studi (KRS)",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _currentView = 1),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "KARTU RENCANA",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "STUDI",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Semester 7",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BottomNav(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Student Info
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: _primaryColor,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PANJALU GALIH AKBAR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "211552000000",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  "IPA / TEKNIK INFORMATIKA S.KOM, M.CS",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Three columns
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _buildKRSColumn(
                              "Mata Kuliah",
                              _krsDataGanjil,
                              true,
                            ),
                            const SizedBox(width: 8),
                            _buildKRSColumn("Semester", _krsDataGenap, false),
                            const SizedBox(width: 8),
                            _buildKRSColumn("SKS", _krsDataSKS, false),
                          ],
                        ),
                      ),
                    ),

                    // Total and buttons
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Total Dipilih : (24 SKS)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white.withValues(alpha: 0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Klik ini jika ingin melihat kartu hasil studi",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKRSColumn(
    String title,
    List<Map<String, dynamic>> items,
    bool isMainColumn,
  ) {
    return Expanded(
      flex: isMainColumn ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isMainColumn
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item["kode"].isNotEmpty)
                                Text(
                                  item["kode"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (item["matkul"].isNotEmpty)
                                Text(
                                  item["matkul"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (item["sks"] != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${item['sks']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        : Center(
                            child: Text(
                              item["sks"] != null ? "${item['sks']}" : "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  // View 2: Kartu Hasil Studi
  Widget _buildHasilStudiView() {
    // Improved Hasil Studi view: banner + prominent first card + list
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor, _primaryColor.withValues(alpha: 0.9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top banner with back button and title
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Kembali',
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'KHS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // keep spacing on the right so title stays centered
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Content list with a highlighted first item
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListView.separated(
                    itemCount: _hasilStudiData.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _hasilStudiData[index];
                      final bool isFirst = index == 0;

                      if (isFirst) {
                        // Prominent white card for the most recent/selected semester
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.description,
                                  color: _primaryColor,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['semester'],
                                      style: TextStyle(
                                        color: _primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['tanggal'],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['status'],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Regular item style (muted card)
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.description,
                                color: _primaryColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['semester'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['tanggal'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                _selectedSemesterIndex = index;
                                _currentView = 2;
                              }),
                              child: const Text(
                                'Lihat Detail',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // View 3: Detail KHS
  Widget _buildDetailKHSView() {
    // reuse detail preview widget for full screen detail view
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor, _primaryColor.withValues(alpha: 0.9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildDetailPreview(_selectedSemesterIndex),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailPreview(int index) {
    if (index < 0 || index >= _hasilStudiData.length) {
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (route) => false,
                ),
              ),
              const Expanded(
                child: Text(
                  "Klik Detail Kartu Hasil Studi",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: Center(
              child: Text(
                "Pilih salah satu riwayat studi di sebelah kiri untuk melihat detail.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      );
    }

    final item = _hasilStudiData[index];

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              ),
            ),
            Expanded(
              child: Text(
                item['semester'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "DETAIL KHS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  // PDF Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          color: _primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['semester'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['status'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Simulated PDF content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Center(child: Text('PDF Preview')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton.icon(
            onPressed: () {
              _generatePDF(item);
            },
            icon: const Icon(Icons.download),
            label: const Text(
              'Unduh PDF',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // profile avatar at bottom
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 40, color: _primaryColor),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
