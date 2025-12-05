import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_service.dart';
import './absen_page.dart';

class KrsDetailPage extends StatefulWidget {
  final int idKrs;
  final String semester;
  final String tahunAjaran;

  const KrsDetailPage({
    super.key,
    required this.idKrs,
    required this.semester,
    required this.tahunAjaran,
  });

  @override
  State<KrsDetailPage> createState() => _KrsDetailPageState();
}

class _KrsDetailPageState extends State<KrsDetailPage> {
  List<dynamic> daftarMatkul = [];
  bool isLoading = true;

  final Color primaryColor = const Color(0xFF4C7F9A);
  final Color backgroundColor = const Color(0xFFFDF7EE);

  @override
  void initState() {
    super.initState();
    _getDetailKrs();
  }

  // ============ BUKA LINK ZOOM ============
  Future<void> _openZoom(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(235, 0, 62, 79),
          content: const Text("Link Zoom tidak tersedia"),
        ),
      );
      return;
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: const Text("Gagal membuka Zoom"),
        ),
      );
    }
  }

  // ============ HAPUS MATAKULIAH ============
  Future<void> _hapusMatakuliah(int idKrsDetail) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.delete(
        "${ApiService.baseUrl}krs/hapus-course-krs?id=$idKrsDetail",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryColor,
          content: Text(response.data['message'] ?? "Matakuliah dihapus",
              style: const TextStyle(color: Colors.white)),
        ),
      );
      _getDetailKrs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: const Text("Gagal menghapus matakuliah"),
        ),
      );
    }
  }

  // ============ GET DETAIL KRS ============
  Future<void> _getDetailKrs() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    final url = "${ApiService.baseUrl}krs/detail-krs?id_krs=${widget.idKrs}";

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          daftarMatkul = response.data['data'] ?? [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: const Text("Gagal memuat detail KRS"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ============ TAMBAH MATKUL MODAL ============
  void _tambahMatkulModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TambahMatkulSheet(
        idKrs: widget.idKrs,
        onSuccess: _getDetailKrs,
        primaryColor: primaryColor,
      ),
    );
  }

  // ============ UI ============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Detail KRS Semester ${widget.semester}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
              floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahMatkulModal,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Matkul",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : daftarMatkul.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada matakuliah\nyang dipilih.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: daftarMatkul.length,
                  itemBuilder: (context, index) {
                    final mk = daftarMatkul[index];
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
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: primaryColor,
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          mk['nama_matakuliah'] ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "SKS: ${mk['jumlah_sks'] ?? '-'} | Dosen: ${mk['dosen'] ?? '-'}\n"
                            "Jadwal: ${mk['nama_hari'] ?? '-'}, ${mk['jam_mulai'] ?? '-'} - ${mk['jam_selesai'] ?? '-'}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.video_camera_front,
                                  color: Color.fromARGB(255, 10, 10, 163)),
                              tooltip: "Buka Zoom",
                              onPressed: () => _openZoom(mk['zoom_link']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              tooltip: "Masuk Absen",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AbsenPage(
                                      idKrsDetail: mk['id'],
                                      namaMatkul: mk['nama_matakuliah'],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.red),
                              tooltip: "Hapus Matakuliah",
                              onPressed: () => _hapusMatakuliah(mk['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// ======================================================
// SHEET TAMBAH MATKUL (ELEGAN)
// ======================================================

class TambahMatkulSheet extends StatefulWidget {
  final int idKrs;
  final VoidCallback onSuccess;
  final Color primaryColor;

  const TambahMatkulSheet({
    super.key,
    required this.idKrs,
    required this.onSuccess,
    required this.primaryColor,
  });

  @override
  State<TambahMatkulSheet> createState() => _TambahMatkulSheetState();
}

class _TambahMatkulSheetState extends State<TambahMatkulSheet> {
  List<dynamic> daftarMatkulTersedia = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMatkul();
  }

  Future<void> loadMatkul() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final res = await dio.get("${ApiService.baseUrl}jadwal/daftar-jadwal");
      setState(() => daftarMatkulTersedia = res.data['jadwals'] ?? []);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat matakuliah")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> tambahMatkul(int idJadwal) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final res = await dio.post(
        "${ApiService.baseUrl}krs/tambah-course-krs",
        data: {"id_krs": widget.idKrs, "id_jadwal": idJadwal},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: widget.primaryColor,
          content: Text(res.data['message'],
              style: const TextStyle(color: Colors.white)),
        ),
      );

      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal menambahkan matakuliah"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(color: widget.primaryColor),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daftarMatkulTersedia.length,
              itemBuilder: (context, index) {
                final mk = daftarMatkulTersedia[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      mk['nama_matakuliah'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "SKS: ${mk['jumlah_sks']} | ${mk['nama_hari']}, "
                      "${mk['jam_mulai']} - ${mk['jam_selesai']}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => tambahMatkul(mk['id']),
                      child: const Text(
                        "Tambah",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
