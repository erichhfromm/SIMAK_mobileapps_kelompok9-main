import 'dart:typed_data';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'face_detector_interface.dart';

class MobileFaceDetector implements IFaceDetector {
  late FaceDetector _faceDetector;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    final options = FaceDetectorOptions(
      enableContours: false,
      enableLandmarks: false,
      enableClassification: false,
      enableTracking: false,
      performanceMode: FaceDetectorMode.fast,
    );
    _faceDetector = FaceDetector(options: options);
    _isInitialized = true;
  }

  @override
  Future<bool> hasFace(Uint8List imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Create a temporary file to save the image bytes
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/temp_face_image.jpg';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await _faceDetector.processImage(inputImage);
      
      // Clean up temp file
      if (await file.exists()) {
        await file.delete();
      }

      return faces.isNotEmpty;
    } catch (e) {
      print("Error detecting face: $e");
      return false;
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _faceDetector.close();
      _isInitialized = false;
    }
  }
}

IFaceDetector createFaceDetector() => MobileFaceDetector();
