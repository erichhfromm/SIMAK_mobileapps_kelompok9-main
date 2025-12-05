import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'camera_interface.dart';

class WebCamera implements ICamera {
  VideoElement? _video;
  CanvasElement? _canvas;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    _video = VideoElement()
      ..autoplay = true
      ..muted = true
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.objectFit = "cover";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'webcam-view',
      (int viewId) => _video!,
    );

    final stream = await window.navigator.mediaDevices!.getUserMedia({
      'video': {'facingMode': 'user'},
      'audio': false,
    });

    _video!.srcObject = stream;
    _canvas = CanvasElement();
    _isInitialized = true;

    print("💻 Kamera Web berhasil diinisialisasi");
  }

  @override
  Widget buildPreview() {
    if (!_isInitialized) {
      return const Center(child: Text("Kamera belum siap"));
    }
    return const HtmlElementView(viewType: 'webcam-view');
  }

  @override
  Future<Uint8List> capture() async {
    if (_video == null) {
      throw Exception("❌ Kamera belum siap");
    }

    _canvas!.width = _video!.videoWidth;
    _canvas!.height = _video!.videoHeight;

    final ctx = _canvas!.context2D;
    ctx.drawImage(_video!, 0, 0);

    // toBlob might return null in some older browser contexts or if failed,
    // but the type signature says Blob? so the check is valid in standard Dart web.
    // However, if the linter says it's always false, it might be due to newer type definitions.
    // We will keep it safe but suppress if needed, or just trust the linter if it says it's non-nullable.
    // Checking the linter message: "The operand can't be 'null', so the condition is always 'false'."
    // This implies toBlob returns a non-nullable Blob in this environment.

    // final blob = await _canvas!.toBlob("image/jpeg", 0.9);
    // return reader.result as Uint8List;

    // Let's just remove the check if the linter insists.
    final blob = await _canvas!.toBlob("image/jpeg", 0.9);

    final reader = FileReader();
    reader.readAsArrayBuffer(blob);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }

  @override
  void dispose() {
    _video?.srcObject?.getTracks().forEach((track) => track.stop());
    _video = null;
    _isInitialized = false;
  }
}

ICamera createCamera() => WebCamera();
