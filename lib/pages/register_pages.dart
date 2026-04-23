import 'package:flutter/material.dart';
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
  final nimController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nimController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _doRegister() async {
    debugPrint("🔵 Register button clicked");

    if (_formKey.currentState!.validate()) {
      debugPrint("✅ Form validation passed");

      setState(() => _isLoading = true);

      final res = await ApiService.register(
        nimController.text,
        emailController.text,
        passwordController.text,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (res['status'] == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Registrasi Berhasil. Silakan Login.',
          onConfirmBtnTap: () {
            Navigator.of(context).pop(); // tutup alert
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPages()),
            );
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: res['error'] ?? 'Registrasi Gagal',
        );
      }
    } else {
      debugPrint("❌ Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(labelText: "NIM / Username"),
                validator: (v) =>
                    v!.isEmpty ? "NIM / Username wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Password wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _doRegister,
                  child: Text(_isLoading ? "Loading..." : "Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
