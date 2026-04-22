import 'camera_interface.dart';
import 'camera_helper_mobile.dart'
    if (dart.library.html) 'camera_helper_web.dart'
    as impl;

ICamera createCamera() => impl.createCamera();
