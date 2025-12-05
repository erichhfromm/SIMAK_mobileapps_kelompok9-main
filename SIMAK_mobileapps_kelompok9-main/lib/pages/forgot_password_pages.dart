import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF517A8E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517A8E),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.white, // 🔹 teks putih
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // 🔹 panah back juga putih
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7EE),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              children: [
                const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D4C5E),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color(0xFF4C7F9A),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF6ECEC),
                    hintText: 'Enter your registered email',
                    hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset link sent!'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
