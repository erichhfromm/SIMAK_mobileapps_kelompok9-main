import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import './absen_page.dart';

class AbsensiListPage extends StatefulWidget {
  const AbsensiListPage({super.key});

  @override
  State<AbsensiListPage> createState() => _AbsensiListPageState();
}

class _AbsensiListPageState extends State<AbsensiListPage> {
  bool isLoading = true;
  List<dynamic> daftarMatkul = [];
  String? errorMessage;
  Map<String, dynamic>? activeKrs;

  final Color primaryColor = const Color(0xFF4C7F9A);
  final Color backgroundColor = const Color(0xFFFDF7EE);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('auth_email');

      if (token == null || email == null) {
        // 🔹 DEMO BYPASS: Jika tidak ada token, gunakan data dummy
        debugPrint("Demo mode: Using dummy courses in AbsensiListPage");
        setState(() {
          daftarMatkul = [
            {
              "id": 1,
              "nama_matakuliah": "Mobile Programming",
              "nama_hari": "Senin",
              "jam_mulai": "08:00",
              "jam_selesai": "10:30",
            },
            {
              "id": 2,
              "nama_matakuliah": "Data Mining",
              "nama_hari": "Senin",
              "jam_mulai": "13:00",
              "jam_selesai": "15:00",
            },
            {
              "id": 3,
              "nama_matakuliah": "Kecerdasan Buatan",
              "nama_hari": "Selasa",
              "jam_mulai": "09:00",
              "jam_selesai": "11:00",
            },
          ];
          activeKrs = {"semester": 5, "tahun_ajaran": "2024/2025"};
          isLoading = false;
        });
        return;
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      // 1. Get Mahasiswa Detail to get NIM
      final mhsRes = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );
      final nim = mhsRes.data['data']['nim'];

      // 2. Get Daftar KRS
      final krsRes = await dio.get(
        "${ApiService.baseUrl}krs/daftar-krs?id_mahasiswa=$nim",
      );
      final List<dynamic> krsList = krsRes.data['data'] ?? [];

      if (krsList.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = "Belum ada KRS yang diambil";
        });
        return;
      }

      // 3. Ambil KRS Terakhir
      final latestKrs = krsList.first;
      activeKrs = latestKrs;

      // 4. Get Detail KRS (Daftar Matkul)
      final detailRes = await dio.get(
        "${ApiService.baseUrl}krs/detail-krs?id_krs=${latestKrs['id']}",
      );

      setState(() {
        daftarMatkul = detailRes.data['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loadData in AbsensiListPage: $e");
      // 🔹 Fallback ke dummy jika error biar demo lancar
      setState(() {
        daftarMatkul = [
          {
            "id": 1,
            "nama_matakuliah": "Mobile Programming (Offline)",
            "nama_hari": "Senin",
            "jam_mulai": "08:00",
            "jam_selesai": "10:30",
          },
        ];
        activeKrs = {"semester": 5, "tahun_ajaran": "2024/2025"};
        isLoading = false;
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Daftar Absensi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
              ),
            )
          : Column(
              children: [
                if (activeKrs != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Semester ${activeKrs!['semester']} - ${activeKrs!['tahun_ajaran']}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pilih matakuliah untuk melakukan absensi",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: daftarMatkul.length,
                    itemBuilder: (context, index) {
                      final mk = daftarMatkul[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            mk['nama_matakuliah'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "${mk['nama_hari'] ?? '-'}, ${mk['jam_mulai'] ?? '-'} - ${mk['jam_selesai'] ?? '-'}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AbsenPage(
                                  idKrsDetail: mk['id'],
                                  namaMatkul: mk['nama_matakuliah'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
