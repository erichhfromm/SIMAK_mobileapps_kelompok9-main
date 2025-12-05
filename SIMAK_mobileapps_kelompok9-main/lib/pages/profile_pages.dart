import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../api/api_service.dart';
import '../pages/kartu_mahasiswa_page.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  Map<String, dynamic>? user;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  // Controller biodata
  final namaC = TextEditingController();
  final jkC = TextEditingController();
  final tglC = TextEditingController();
  final alamatC = TextEditingController();
  final statusC = TextEditingController();

  Uint8List? webImage;
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    _getMahasiswaData();
  }

  Future<void> _getMahasiswaData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final email = prefs.getString('auth_email');

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.post(
      "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
      data: {"email": email},
    );

    // 🧩 Tambahan: print log untuk melihat struktur data dari API
    print("📦 Data user dari API: ${response.data['data']}");

    setState(() {
      user = response.data['data'];
      namaC.text = user?['nama'] ?? '';
      jkC.text = user?['jenis_kelamin'] ?? '';
      tglC.text = user?['tanggal_lahir'] ?? '';
      alamatC.text = user?['alamat'] ?? '';
      statusC.text = user?['status'] ?? '';
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          webImage = bytes;
          pickedFile = image;
        });
        _uploadFotoWeb(bytes, image.name);
      } else {
        setState(() {
          pickedFile = image;
        });
        _uploadFotoMobile(image);
      }
    }
  }

  Future<void> _uploadFotoMobile(XFile image) async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final nim = user?['nim'];

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final formData = FormData.fromMap({
        'nim': nim,
        'foto': await MultipartFile.fromFile(image.path),
      });

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/upload-foto-mahasiswa",
        data: formData,
      );

      if (response.data['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto profil berhasil diperbarui!")),
        );
        _getMahasiswaData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal upload foto: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _uploadFotoWeb(Uint8List bytes, String filename) async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final nim = user?['nim'];

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final formData = FormData.fromMap({
        'nim': nim,
        'foto': MultipartFile.fromBytes(bytes, filename: filename),
      });

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/upload-foto-mahasiswa",
        data: formData,
      );

      if (response.data['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto profil berhasil diperbarui!")),
        );
        _getMahasiswaData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal upload foto: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateBiodata() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final nim = user?['nim'];

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.put(
        "${ApiService.baseUrl}mahasiswa/update-mahasiswa",
        data: {
          "nim": nim,
          "nama": namaC.text,
          "jenis_kelamin": jkC.text,
          "tanggal_lahir": tglC.text,
          "alamat": alamatC.text,
          "status": statusC.text,
        },
      );

      if (response.data['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biodata berhasil diperbarui!")),
        );
        _getMahasiswaData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update biodata: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(tglC.text) ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4C7F9A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF4C7F9A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        tglC.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fotoUrl = user?["foto"];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
        title: const Text(
          "Profil Mahasiswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4C7F9A)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // ===== FOTO PROFIL =====
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: kIsWeb && webImage != null
                                ? MemoryImage(webImage!)
                                : pickedFile != null
                                    ? Image.network(pickedFile!.path).image
                                    : (fotoUrl != null && fotoUrl != "")
                                        ? NetworkImage(fotoUrl)
                                        : const AssetImage("assets/images/default_user.png")
                                            as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4C7F9A),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ===== FORM BIODATA =====
                    _buildTextField("Nama", namaC, validator: true),
                    _buildTextField("Jenis Kelamin", jkC),
                    _buildDateField("Tanggal Lahir", tglC, context),
                    _buildTextField("Alamat", alamatC),
                    _buildTextField("Status", statusC),
                    const SizedBox(height: 25),

                    // ===== BUTTON SIMPAN =====
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _updateBiodata,
                            icon: const Icon(Icons.save),
                            label: Text(isLoading ? "Menyimpan..." : "Simpan Perubahan"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4C7F9A),
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KartuMahasiswaPage(user: user!),
                                ),
                              );
                            },
                            icon: const Icon(Icons.credit_card),
                            label: const Text("Lihat Kartu Mahasiswa"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool validator = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF4C7F9A)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4C7F9A), width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4C7F9A), width: 1.5),
          ),
        ),
        validator: validator ? (v) => v!.isEmpty ? "$label wajib diisi" : null : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF4C7F9A)),
          labelStyle: const TextStyle(color: Color(0xFF4C7F9A)),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4C7F9A), width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4C7F9A), width: 1.5),
          ),
        ),
      ),
    );
  }
}
