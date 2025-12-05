import 'package:flutter/material.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EF),
      body: Stack(
        children: [
          // 🌊 Wave biru atas
          ClipPath(
            clipper: BlueWaveClipper(),
            child: Container(
              height: size.height * 0.55,
              width: size.width,
              color: const Color(0xFF4C7F9A),
            ),
          ),

          // 🌟 Konten utama
          SafeArea(
            child: Column(
              children: [
                // 🔹 Logo & teks My SWU di pojok kiri atas
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo_swu.png',
                        width: 42,
                        height: 42,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'My SWU',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 🔸 Tombol & teks utama di tengah
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Create Account (lebih naik sedikit)
                      SizedBox(
                        width: 220,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A628A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 3,
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Teks Log in (juga naik sedikit)
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              color: Color(0xFF4A628A),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),

                      // Tambah jarak sebelum tagline ✨
                      const SizedBox(height: 30),

                      // Tagline
                      const Text(
                        "Smart. Winner. Universe.",
                        style: TextStyle(
                          color: Color.fromARGB(255, 251, 230, 5),
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40), // dikurangi biar konten naik
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🌊 Wave versi lembut dan dinamis
class BlueWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 100);

    // Gelombang kiri tinggi
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - 160,
      size.width * 0.5,
      size.height - 90,
    );

    // Gelombang kanan turun lembut
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 100,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
