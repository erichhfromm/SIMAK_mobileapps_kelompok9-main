import 'package:flutter/material.dart';
import '../pages/dashboard_pages.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    // Langsung tampilkan halaman Dashboard sebagai pengganti pilihan navbar
    return const DashboardPages();
  }
}
