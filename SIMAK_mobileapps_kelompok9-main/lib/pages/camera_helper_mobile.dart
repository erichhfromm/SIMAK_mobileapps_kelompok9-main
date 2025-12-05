import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'camera_interface.dart';

class MobileCamera implements ICamera {
  CameraController? controller;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    _isInitialized = true;

    print("📱 Kamera Mobile berhasil diinisialisasi");
  }

  @override
  Future<Uint8List> capture() async {
    if (!_isInitialized || controller == null) {
      throw Exception("❌ Kamera belum siap");
    }

    final file = await controller!.takePicture();
    return await file.readAsBytes();
  }

  @override
  Widget buildPreview() {
    if (!_isInitialized || controller == null) {
      return const Center(child: Text("Kamera belum siap"));
    }
    return CameraPreview(controller!);
  }

  @override
  void dispose() {
    controller?.dispose();
    controller = null;
    _isInitialized = false;
  }
}

ICamera createCamera() => MobileCamera();
