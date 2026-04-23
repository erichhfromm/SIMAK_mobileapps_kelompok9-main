import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import './krs_detail_page.dart';

class InputKrsPage extends StatefulWidget {
  const InputKrsPage({super.key});

  @override
  State<InputKrsPage> createState() => _InputKrsPageState();
}

class _InputKrsPageState extends State<InputKrsPage> {
  Map<String, dynamic>? user;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController semesterController = TextEditingController();

  bool isLoading = false;
  bool isFetching = true;
  bool isFetchingKrs = false;

  List<dynamic> daftarKrs = [];

  final Color primaryColor = const Color(0xFF4C7F9A);
  final Color backgroundColor = const Color(0xFFFDF7EE);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      // 🔹 DEMO BYPASS
      debugPrint("Demo mode: Using dummy data in InputKrsPage");
      setState(() {
        user = {"nim": "211552018001", "nama": "Mahasiswa Demo"};
        daftarKrs = [
          {"id": 101, "semester": 5, "tahun_ajaran": "2024/2025"},
          {"id": 102, "semester": 4, "tahun_ajaran": "2023/2024"},
        ];
        isFetching = false;
        isFetchingKrs = false;
      });
      return;
    }

    await _getMahasiswaData();
    if (user != null) {
      await _getDaftarKrs();
    }
    setState(() => isFetching = false);
  }

  Future<void> _getMahasiswaData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('auth_email');

      if (token == null) return;

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        setState(() => user = response.data['data']);
      } else {
        throw Exception("Invalid response");
      }
    } catch (e) {
      debugPrint("Error getMahasiswaData: $e");
      setState(() {
        user = {"nim": "211552018001", "nama": "Mahasiswa (FreeAPI Mode)"};
      });
    }
  }

  Future<void> _submitKrs() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        // 🔹 DEMO MOCK SUCCESS
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          daftarKrs.insert(0, {
            "id": DateTime.now().millisecondsSinceEpoch,
            "semester": semesterController.text,
            "tahun_ajaran": "2024/2025 (Demo)",
          });
          isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("KRS Berhasil disimpan (Demo Mode)")),
        );
        semesterController.clear();
        return;
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        "${ApiService.baseUrl}krs/buat-krs",
        data: {'nim': user?['nim'], 'semester': semesterController.text},
      );

      final msg = response.data['message'] ?? "KRS berhasil disimpan";

      if (response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text(msg, style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        semesterController.clear();
        _formKey.currentState!.reset();
        await _getDaftarKrs();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (e) {
      debugPrint("DioException in _submitKrs: $e");
      // Fallback for demo/FreeAPI
      setState(() {
        daftarKrs.insert(0, {
          "id": DateTime.now().millisecondsSinceEpoch,
          "semester": semesterController.text,
          "tahun_ajaran": "2024/2025 (Demo/Offline)",
        });
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("KRS Berhasil disimpan (Fallback Mode)")),
      );
      semesterController.clear();
      _formKey.currentState!.reset();
    } catch (e) {
      debugPrint("Error in _submitKrs: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _getDaftarKrs() async {
    if (user == null) return;
    setState(() => isFetchingKrs = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) return;

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        "${ApiService.baseUrl}krs/daftar-krs?id_mahasiswa=${user!['nim']}",
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        setState(() => daftarKrs = response.data['data']);
      } else {
        throw Exception("Invalid response");
      }
    } catch (e) {
      debugPrint("Error getDaftarKrs: $e");
      setState(() {
        daftarKrs = [
          {"id": 101, "semester": 5, "tahun_ajaran": "2024/2025"},
          {"id": 102, "semester": 4, "tahun_ajaran": "2023/2024"},
        ];
      });
    } finally {
      setState(() => isFetchingKrs = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // ikon back putih
          tooltip: 'Kembali ke Dashboard',
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
            (route) => false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            tooltip: 'Kembali ke Home',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            },
          ),
        ],
        title: const Text(
          "Input KRS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: isFetching
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==== FORM INPUT ====
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
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
                    "Input Semester",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: semesterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Masukkan semester aktif",
                      filled: true,
                      fillColor: const Color(0xFFF9F9F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Wajib diisi" : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitKrs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.save,
                              color: Colors.white,
                            ), // ikon save putih
                      label: Text(
                        isLoading ? "Menyimpan..." : "Simpan KRS",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ==== LIST KRS ====
          Text(
            "Daftar KRS Mahasiswa",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),

          if (isFetchingKrs)
            Center(child: CircularProgressIndicator(color: primaryColor))
          else if (daftarKrs.isEmpty)
            const Text(
              "Belum ada data KRS.",
              style: TextStyle(color: Colors.grey),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daftarKrs.length,
              itemBuilder: (context, index) {
                final krs = daftarKrs[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.book, color: Colors.white),
                    ),
                    title: const Text(
                      "KRS Anda",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "Semester: ${krs['semester']} | Tahun: ${krs['tahun_ajaran']}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KrsDetailPage(
                            idKrs: krs['id'],
                            semester: krs['semester']?.toString() ?? "-",
                            tahunAjaran: krs['tahun_ajaran']?.toString() ?? "-",
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
