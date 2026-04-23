import 'package:flutter/foundation.dart';
import 'face_detector_interface.dart';

class WebFaceDetector implements IFaceDetector {
  @override
  Future<void> initialize() async {
    // No-op for web
  }

  @override
  Future<bool> hasFace(Uint8List imageBytes) async {
    // 🔹 SIMULASI: Tambahkan delay agar terasa seperti sedang mendeteksi
    debugPrint("WebFaceDetector: Mendeteksi wajah...");
    await Future.delayed(const Duration(milliseconds: 1500));

    // Face detection is not supported natively via google_mlkit on Web.
    // For web, we gracefully return true so it doesn't block the user.
    debugPrint("WebFaceDetector: Wajah terdeteksi!");
    return true;
  }

  @override
  void dispose() {
    // No-op
  }
}

IFaceDetector createFaceDetector() => WebFaceDetector();
