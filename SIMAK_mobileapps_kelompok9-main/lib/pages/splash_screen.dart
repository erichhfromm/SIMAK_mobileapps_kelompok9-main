import 'package:flutter/material.dart';
import 'package:siakad/pages/welcome_page.dart';
// arah setelah splash

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // delay 15 detik lalu pindah ke login
    Future.delayed(const Duration(seconds: 10), () {
    Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const WelcomePage()),
);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C7F9A), // warna biru dari figma
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_swu.png', // tambahkan logomu di folder assets
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'My SWU',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
