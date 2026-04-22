import 'dart:typed_data';

abstract class IFaceDetector {
  Future<void> initialize();
  Future<bool> hasFace(Uint8List imageBytes);
  void dispose();
}
