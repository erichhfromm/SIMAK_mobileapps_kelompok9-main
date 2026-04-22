import 'package:flutter/material.dart';
import 'pages/ujian_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Ujian Pages',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestHomePage(),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Ujian Pages')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UjianPages()),
            );
          },
          child: const Text('Buka Halaman Ujian'),
        ),
      ),
    );
  }
}
