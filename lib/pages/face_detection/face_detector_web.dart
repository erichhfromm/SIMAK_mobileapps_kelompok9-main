import 'dart:typed_data';
import 'face_detector_interface.dart';

class WebFaceDetector implements IFaceDetector {
  @override
  Future<void> initialize() async {
    // No-op for web
  }

  @override
  Future<bool> hasFace(Uint8List imageBytes) async {
    // Face detection is not supported natively via google_mlkit on Web.
    // For web, we gracefully return true so it doesn't block the user.
    return true;
  }

  @override
  void dispose() {
    // No-op
  }
}

IFaceDetector createFaceDetector() => WebFaceDetector();
