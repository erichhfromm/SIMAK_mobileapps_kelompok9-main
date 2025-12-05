import 'package:flutter/material.dart';
import 'package:siakad/pages/splash_screen.dart';
import 'package:siakad/pages/welcome_page.dart';
import 'package:siakad/pages/login_pages.dart';
import 'package:siakad/pages/register_pages.dart';
import 'package:siakad/widgets/bottom_nav.dart'; // halaman utama (navbar + dashboard)
import 'pages/tugas_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KELOMPOK 9',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C7F9A)),
        primaryColor: const Color(0xFF4C7F9A),
        scaffoldBackgroundColor: const Color(0xFFFDF7EE),
        useMaterial3: true,
      ),

      // 🔹 Semua rute aplikasi didefinisikan di sini
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPages(),
        '/register': (context) => const RegisterPages(),
        '/main': (context) => const BottomNav(),

        // ⚠️ Detail tugas butuh parameter via arguments
        '/tugas_detail': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return TugasDetailPage(
            matkul: args["matkul"] ?? "",
            judul: args["judul"] ?? "",
            deadline: args["deadline"] ?? "",
          );
        },
      },

      // 🔹 Halaman pertama saat app dibuka
      home: const SplashScreen(),

      // 🔹 Layout responsif tengah
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(color: Colors.white, child: child),
          ),
        );
      },
    );
  }
}
