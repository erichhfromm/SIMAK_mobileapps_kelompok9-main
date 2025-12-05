// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui;

// Interface untuk kamera
abstract class ICamera {
  Future<void> initialize();
  Future<Uint8List> capture();
  void dispose();
}

// WebCamera implement ICamera
class WebCamera implements ICamera {
  html.VideoElement? _video;
  html.CanvasElement? _canvas;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    _video = html.VideoElement()
      ..autoplay = true
      ..controls = false
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.borderRadius = '12px';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'webcam-view',
      (int viewId) => _video!,
    );

    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': {'facingMode': 'user'}});
      _video!.srcObject = stream;
      await _video!.play();
      _isInitialized = true;
      print("✅ Kamera berhasil diinisialisasi (Web)");
    } catch (e) {
      print("❌ Gagal akses kamera: $e");
      rethrow;
    }
  }

  @override
  Future<Uint8List> capture() async {
    if (!_isInitialized || _video == null) {
      throw Exception("Kamera belum siap");
    }
    _canvas = html.CanvasElement(
      width: _video!.videoWidth,
      height: _video!.videoHeight,
    );
    final ctx = _canvas!.context2D;
    ctx.drawImage(_video!, 0, 0);

    final blob = await _canvas!.toBlob('image/png');
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();
    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((_) {
      completer.complete(reader.result as Uint8List);
    });

    return completer.future;
  }

  @override
  void dispose() {
    _video?.srcObject?.getTracks().forEach((track) => track.stop());
    _video = null;
    _canvas = null;
    _isInitialized = false;
  }
}

// Stub MobileCamera untuk Web
class MobileCamera implements ICamera {
  MobileCamera();
  @override
  Future<void> initialize() async {}
  @override
  Future<Uint8List> capture() async => Uint8List(0);
  @override
  void dispose() {}
}
