import 'face_detector_interface.dart';
import 'face_detector_mobile.dart'
    if (dart.library.html) 'face_detector_web.dart' as impl;

IFaceDetector createFaceDetector() => impl.createFaceDetector();
