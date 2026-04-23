import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './absen_qr_page.dart';
import './detail_absensi_page.dart';
import '../api/api_service.dart';

class AbsenPage extends StatefulWidget {
  final int idKrsDetail;
  final String namaMatkul;

  const AbsenPage({
    super.key,
    required this.idKrsDetail,
    required this.namaMatkul,
  });

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  List<bool> sudahAbsen = List.generate(16, (_) => false);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatusAbsen();
  }

  Future<void> loadStatusAbsen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // 🔹 DEMO BYPASS
      if (token == null) {
        debugPrint("Demo mode: Using dummy attendance status in AbsenPage");
        setState(() {
          // Simulasi beberapa pertemuan sudah absen (index 0, 1, 2)
          sudahAbsen[0] = true;
          sudahAbsen[1] = true;
          sudahAbsen[2] = true;
          isLoading = false;
        });
        return;
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      for (int i = 1; i <= 16; i++) {
        final url =
            "${ApiService.baseUrl}absensi/detail?id_krs_detail=${widget.idKrsDetail}&pertemuan=$i";

        try {
          final res = await dio.get(url);
          if (res.data["data"] != null) {
            sudahAbsen[i - 1] = true;
          }
        } catch (e) {
          // skip jika gagal
        }
      }

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Error loadStatusAbsen: $e");
      setState(() => isLoading = false);
      // fallback dummy jika error
      setState(() {
        sudahAbsen[0] = true;
        sudahAbsen[1] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // panah putih
        ),
        title: Text(
          "Absen - ${widget.namaMatkul}",
          style: const TextStyle(
            color: Colors.white, // tulisan putih
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Container(
        color: const Color(0xFFFDF7EE),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 16,
                itemBuilder: (context, index) {
                  final pertemuan = index + 1;
                  final isDone = sudahAbsen[index];

                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: isDone ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        "Pertemuan $pertemuan",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D4C5E),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDone)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C7F9A),
                                foregroundColor: Colors.white, // teks putih
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailAbsensiPage(
                                      idKrsDetail: widget.idKrsDetail,
                                      pertemuan: pertemuan,
                                      namaMatkul: widget.namaMatkul,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Lihat"),
                            ),

                          if (isDone) const SizedBox(width: 8),

                          if (!isDone)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C7F9A),
                                foregroundColor: Colors.white, // teks putih
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AbsenQRPage(
                                      idKrsDetail: widget.idKrsDetail,
                                      pertemuan: pertemuan,
                                      namaMatkul: widget.namaMatkul,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Absen"),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
