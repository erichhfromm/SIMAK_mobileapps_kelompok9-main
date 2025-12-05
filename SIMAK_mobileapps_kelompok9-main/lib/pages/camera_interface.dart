import 'dart:typed_data';
import 'package:flutter/widgets.dart';

abstract class ICamera {
  Future<void> initialize();
  Future<Uint8List> capture();
  Widget buildPreview();
  void dispose();
}
