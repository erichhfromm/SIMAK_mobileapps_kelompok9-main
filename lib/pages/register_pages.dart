import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../api/api_service.dart';
import 'login_pages.dart';

class RegisterPages extends StatefulWidget {
  const RegisterPages({super.key});

  @override
  State<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends State<RegisterPages> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController(); // BARU: NIM
  final _tglLahirController = TextEditingController();
  String? _jenisKelamin;
  final _alamat = TextEditingController();
  final _angkatan = TextEditingController();
  final _id_tahun = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false; // Loading state

  void _registerAct() async {
    debugPrint("🔵 Register button clicked");

    if (_formKey.currentState!.validate()) {
      debugPrint("✅ Form validation passed");

      setState(() => _isLoading = true); // Start loading

      final nama = _nameController.text;
      final nim = _nimController.text;
      final tglLahir = _tglLahirController.text;
      final jenisKelamin = _jenisKelamin;
      final alamat = _alamat.text;
      final angkatan = _angkatan.text;
      final idTahun = _id_tahun.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      debugPrint("📝 Data to send:");
      debugPrint("  Nama: $nama");
      debugPrint("  NIM: $nim");
      debugPrint("  Email: $email");

      try {
        final dio = Dio();
        debugPrint("🌐 Sending request to: ${ApiService.baseUrl}auth/register");

        final response = await dio.post(
          '${ApiService.baseUrl}auth/register',
          data: {
            'nama': nama,
            'nim': nim,
            'tgl_lahir': tglLahir,
            'jenis_kelamin': jenisKelamin,
            'alamat': alamat,
            'angkatan': angkatan,
            'id_tahun': idTahun,
            'email': email,
            'password': password,
          },
        );

        debugPrint("📥 Response received: ${response.data}");

        if (response.data['status'] == 200) {
          debugPrint("✅ Registration successful");
          if (!mounted) return;

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Registrasi Berhasil',
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        } else {
          debugPrint("⚠️ Registration failed: ${response.data}");
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Registrasi gagal: ${response.data['message'] ?? 'Unknown error'}",
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint("❌ Error during registration: $e");
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal registrasi: $e")));
      } finally {
        setState(() => _isLoading = false); // Stop loading
      }
    } else {
      debugPrint("❌ Form validation failed");
    }
  }

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1999),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white), // PANAH PUTIH ✅
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Name tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // NIM (BARU)
                  TextFormField(
                    controller: _nimController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'NIM (Nomor Induk Mahasiswa)',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "NIM tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Lahir
                  TextFormField(
                    controller: _tglLahirController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'Tanggal Lahir',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: _pilihTanggal,
                    validator: (v) =>
                        v!.isEmpty ? "Tanggal lahir wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  // Jenis Kelamin
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'Jenis Kelamin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    initialValue: _jenisKelamin,
                    items: const [
                      DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                      DropdownMenuItem(value: "P", child: Text("Perempuan")),
                    ],
                    onChanged: (value) => setState(() => _jenisKelamin = value),
                    validator: (v) => v == null ? "Pilih jenis kelamin" : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6ECEC),
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Email tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Alamat
                  TextFormField(
                    controller: _alamat,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6ECEC),
                      hintText: 'Alamat',
                      prefixIcon: const Icon(Icons.home),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Angkatan
                  TextFormField(
                    controller: _angkatan,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6ECEC),
                      hintText: 'Angkatan',
                      prefixIcon: const Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Angkatan tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Tahun Masuk
                  TextFormField(
                    controller: _id_tahun,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6ECEC),
                      hintText: 'Tahun Masuk',
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty
                        ? "Tahun Masuk tidak boleh kosong"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6ECEC),
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Password tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6ECEC),
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value != _passwordController.text
                        ? "Password tidak sesuai"
                        : null,
                  ),
                  const SizedBox(height: 25),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C7F9A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _registerAct,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Already have account
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPages(),
                        ),
                      );
                    },
                    child: const Text(
                      "Already have an account? Log in",
                      style: TextStyle(
                        color: Color.fromARGB(255, 76, 154, 127),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
