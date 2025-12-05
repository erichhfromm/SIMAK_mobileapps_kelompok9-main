import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:siakad/pages/dashboard_pages.dart';
import '../api/api_service.dart';
import 'register_pages.dart';
import 'forgot_password_pages.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final nimOrEmailController = TextEditingController(); // Bisa NIM atau Email
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> doLogin() async {
    setState(() => isLoading = true);
    final res = await ApiService.login(
      nimOrEmailController.text, // Bisa NIM atau Email
      passwordController.text,
    );

    if (res['status'] == 200) {
      await ApiService.saveToken(res['data'], nimOrEmailController.text);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Login Berhasil',
        onConfirmBtnTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPages()),
          );
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'NIM/Email atau Password Salah!', // Update pesan error
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF517A8E),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // KOTAK UTAMA
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Bagian atas biru soft
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C93A6), // versi soft dari 4C7F9A
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4C7F9A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 10,
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/logo_swu.png',
                                    height: 70,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'My SWU',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bagian bawah krim
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDF7EE),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 30,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Input NIM atau Email
                            TextField(
                              controller: nimOrEmailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your NIM or email',
                                prefixIcon: const Icon(
                                  Icons.badge_outlined,
                                  color: Color(0xFF4C7F9A),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF6ECEC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Input Password
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF4C7F9A),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF6ECEC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Forgot Password
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Color(0xFF2D4C5E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDF7EE),
                      foregroundColor: const Color(0xFF2D4C5E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: isLoading ? null : doLogin,
                    child: Text(
                      isLoading ? 'Loading...' : 'Login',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Don’t have an account? Register now
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        "Don’t have an account? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPages(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
