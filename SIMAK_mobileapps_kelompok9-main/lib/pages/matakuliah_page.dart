import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../api/api_service.dart';

class DaftarMatakuliahPage extends StatefulWidget {
  const DaftarMatakuliahPage({super.key});

  @override
  State<DaftarMatakuliahPage> createState() => _DaftarMatakuliahPageState();
}

class _DaftarMatakuliahPageState extends State<DaftarMatakuliahPage> {
  List<dynamic> daftarMatakuliah = [];
  bool isLoading = true;
  String? errorMessage;

  final Color primaryColor = const Color(0xFF4C7F9A);
  final Color backgroundColor = const Color(0xFFFDF7EE);

  @override
  void initState() {
    super.initState();
    fetchMatakuliah();
  }

  Future<void> fetchMatakuliah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        '${ApiService.baseUrl}matakuliah/daftar-matakuliah',
      );

      if (response.statusCode == 200 && response.data["status"] == 200) {
        setState(() {
          daftarMatakuliah = response.data["data"];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response.data["msg"] ?? 'Gagal memuat data';
          isLoading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        errorMessage =
            e.response?.data["message"] ?? 'Terjadi kesalahan koneksi';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
  elevation: 0,
  backgroundColor: primaryColor,
  iconTheme: const IconThemeData(color: Colors.white), // ← panah back jadi putih
  title: const Text(
    'Daftar Mata Kuliah Dipilih',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white, // title putih
      letterSpacing: 0.5,
    ),
  ),
  centerTitle: true,
),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red[700], fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  color: primaryColor,
                  onRefresh: fetchMatakuliah,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: daftarMatakuliah.length,
                    itemBuilder: (context, index) {
                      final mk = daftarMatakuliah[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: primaryColor,
                            child: Text(
                              mk['jumlah_sks'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            mk['nama_matakuliah'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[900],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kode: ${mk['kode']}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Semester: ${mk['semester']}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: primaryColor,
                            size: 28,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: primaryColor,
                                content: Text(
                                  'Anda memilih ${mk['nama_matakuliah']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
