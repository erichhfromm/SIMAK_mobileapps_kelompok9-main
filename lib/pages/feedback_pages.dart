import 'package:flutter/material.dart';

class FeedbackPages extends StatefulWidget {
  const FeedbackPages({super.key});

  @override
  State<FeedbackPages> createState() => _FeedbackPagesState();
}

class _FeedbackPagesState extends State<FeedbackPages> {
  final TextEditingController feedbackController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C7F9A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ====== BACK ARROW + CENTER TITLE ======
            Stack(
              children: [
                // Back arrow di kiri
                Positioned(
                  left: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back, // ← panah biasa
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),

                // Title di tengah
                const Center(
                  child: Text(
                    "FEEDBACK",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ====== CARD ======
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close_rounded, size: 28),
                            ),
                          ),
                          const SizedBox(height: 10),

                          const Text(
                            "Kami menghargai masukan Anda.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4C7F9A),
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Kami selalu berusaha meningkatkan kualitas layanan. "
                            "Silakan berikan penilaian dan sampaikan pendapat Anda agar "
                            "kami bisa menjadi lebih baik.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),

                          const SizedBox(height: 25),

                          // Textfield D9D9D9
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: feedbackController,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                hintText:
                                    "Tuliskan saran atau masukan Anda di sini...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _sendFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C7F9A),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "KIRIM MASUKAN SAYA",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            // ====== FOOTER DI PALING BAWAH ======
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Smart Winner Universe\nSmart Solution for Smart Campus",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 230, 5),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendFeedback() async {
    if (feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silahkan isi masukan Anda terlebih dahulu untuk dikirim."),
          backgroundColor: Color.fromARGB(255, 225, 0, 0),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Terima kasih atas masukan Anda!"),
        backgroundColor: Color.fromARGB(255, 2, 95, 108),
      ),
    );

    Navigator.pop(context);
  }
}
