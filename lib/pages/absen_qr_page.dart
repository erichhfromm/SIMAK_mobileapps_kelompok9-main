import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'camera_interface.dart';
import 'camera_factory.dart';
import 'face_detection/face_detector_interface.dart';
import 'face_detection/face_detector_factory.dart';
import '../api/notification_service.dart';

class AbsenQRPage extends StatefulWidget {
  final int idKrsDetail;
  final int pertemuan;
  final String namaMatkul;

  const AbsenQRPage({
    super.key,
    required this.idKrsDetail,
    required this.pertemuan,
    required this.namaMatkul,
  });

  @override
  State<AbsenQRPage> createState() => _AbsenQRPageState();
}

class _AbsenQRPageState extends State<AbsenQRPage> {
  int _currentStep =
      1; // 0: QR Scan (removed), 1: Upload Foto, 2: Konfirmasi, 3: Success

  // Data
  Uint8List? _imageBytes;
  Position? _position;
  String? _address;
  ICamera? _cam;

  // States
  bool _isCameraReady = false;
  bool _isSubmitting = false;
  bool _isLoadingLocation = false;
  late IFaceDetector _faceDetector;

  final Color _primaryColor = const Color(0xFF4C7F9A);
  final Color _backgroundColor = const Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    _faceDetector = createFaceDetector();
    _faceDetector.initialize();
    // langsung inisialisasi kamera agar masuk ke langkah upload/photo
    _initializeCamera();
    _getLocation(); // Request location automatically on entry
  }

  @override
  void dispose() {
    try {
      _cam?.dispose();
    } catch (_) {}
    _faceDetector.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cam = createCamera();
      await _cam!.initialize();
      setState(() => _isCameraReady = true);
    } catch (e) {
      debugPrint("Error init camera: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal akses kamera: $e")));
      }
    }
  }

  Future<void> _capturePhoto() async {
    try {
      if (_cam == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Kamera tidak tersedia")));
        return;
      }

      setState(() => _isSubmitting = true);
      final Uint8List data = await _cam!.capture();

      bool hasFace = await _faceDetector.hasFace(data);
      setState(() => _isSubmitting = false);

      if (!hasFace) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Wajah tidak terdeteksi. Silakan ambil foto ulang.",
              ),
            ),
          );
        }
        return;
      }

      setState(() {
        _imageBytes = data;
        _currentStep = 2; // Move to confirmation step
      });

      // Auto get location after photo
      await _getLocation();
    } catch (e) {
      debugPrint("Capture error: $e");
      if (mounted) setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil foto")));
    }
  }

  Future<void> _pickFromFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          setState(() => _isSubmitting = true);
          bool hasFace = await _faceDetector.hasFace(file.bytes!);
          setState(() => _isSubmitting = false);

          if (!hasFace) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Wajah tidak terdeteksi pada gambar. Silakan pilih foto lain.",
                  ),
                ),
              );
            }
            return;
          }

          setState(() {
            _imageBytes = file.bytes;
            _currentStep = 2; // move to confirmation
          });

          // try to get location after picking
          await _getLocation();
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal membaca file gambar")),
          );
        }
      }
    } catch (e) {
      debugPrint("File pick error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memilih file gambar")),
      );
    }
  }

  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("GPS/Lokasi tidak aktif. Silakan aktifkan."),
            action: SnackBarAction(
              label: "Settings",
              onPressed: () => Geolocator.openLocationSettings(),
            ),
          ),
        );
        return;
      }

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin lokasi diperlukan untuk absensi")),
        );
        return;
      }

      if (perm == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Izin lokasi ditolak permanen."),
            action: SnackBarAction(
              label: "Settings",
              onPressed: () => Geolocator.openAppSettings(),
            ),
          ),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => _position = pos);

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _address =
                "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}";
          });
        }
      } catch (e) {
        debugPrint("Reverse geocoding error: $e");
        setState(() => _address = "Alamat tidak ditemukan");
      }
    } catch (e) {
      debugPrint("Location error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil lokasi")));
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _copyLocationToClipboard() async {
    if (_position == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lokasi belum tersedia')));
      return;
    }

    final text =
        'Lokasi saya: https://www.google.com/maps/search/?api=1&query=${_position!.latitude},${_position!.longitude}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tautan lokasi disalin ke clipboard')),
    );
  }

  Future<void> _openLocationInMaps() async {
    if (_position == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lokasi belum tersedia')));
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${_position!.latitude},${_position!.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka aplikasi peta')),
      );
    }
  }

  Future<void> _submitAbsen() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto belum diambil")));
      return;
    }
    if (_position == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lokasi belum diambil")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1. Validasi Face Detection
      // Wajah sudah divalidasi saat capture/pick file

      // 2. Validasi Geofencing (Jarak) - 🔹 Bypass untuk DEMO
      debugPrint("Demo mode: Bypassing geofencing distance check");

      // 3. Submit Absen - 🔹 Bypass API call untuk DEMO
      debugPrint("Demo mode: Mocking attendance submission");
      await Future.delayed(
        const Duration(seconds: 1),
      ); // simulasi network latency

      setState(() => _currentStep = 3); // Success step

      // 🔹 Simulasi Notifikasi via NotificationService
      if (mounted) {
        await NotificationService().showDemoNotification(
          context: context,
          title: "Absensi Berhasil",
          body:
              "Kehadiran untuk ${widget.namaMatkul} Pertemuan ${widget.pertemuan} telah dicatat.",
        );
      }

      // Auto close after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context, true);
      });
    } catch (e) {
      debugPrint("Submit error: $e");
      // 🔹 Fallback success untuk demo jika ada error tak terduga
      setState(() => _currentStep = 3);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context, true);
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentStep == 0
              ? "Code Or Kehadiran"
              : _currentStep == 3
              ? "Scan Verified"
              : "Scan Verified",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Upload dari File',
            icon: const Icon(Icons.upload_file, color: Colors.white),
            onPressed: _pickFromFiles,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Widget stepWidget;
    switch (_currentStep) {
      case 0:
        stepWidget = _buildQRScanStep();
        break;
      case 1:
        stepWidget = _buildUploadPhotoStep();
        break;
      case 2:
        stepWidget = _buildConfirmationStep();
        break;
      case 3:
        stepWidget = _buildSuccessStep();
        break;
      default:
        stepWidget = _buildQRScanStep();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(_currentStep),
        child: stepWidget,
      ),
    );
  }

  // Step 1: QR Scan
  Widget _buildQRScanStep() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Silahkan scan QR code untuk\nmencatat kehadiran anda",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            // QR Code Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      size: 120,
                      color: Color(0xFF4C7F9A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Scan QR Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  // Simulasi scan berhasil
                  setState(() => _currentStep = 1);
                  _initializeCamera();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8D5B7),
                  foregroundColor: const Color(0xFF2C3E50),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Buka Kamera",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 2: Upload Photo
  Widget _buildUploadPhotoStep() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Upload Foto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Camera Preview or Captured Image
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _imageBytes != null
                    ? Image.memory(
                        _imageBytes!,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : _isCameraReady && _cam != null
                    ? SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: _cam!.buildPreview(),
                      )
                    : Container(
                        width: double.infinity,
                        height: 300,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_imageBytes == null)
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isCameraReady ? _capturePhoto : null,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text(
                            "Ambil Foto",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8D5B7),
                            foregroundColor: const Color(0xFF2C3E50),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _pickFromFiles,
                          icon: const Icon(
                            Icons.upload_file,
                            color: Color(0xFF2C3E50),
                          ),
                          label: const Text(
                            "Pilih dari File",
                            style: TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2C3E50),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _imageBytes = null;
                          _position = null;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        "Ambil Ulang",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8D5B7),
                        foregroundColor: const Color(0xFF2C3E50),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Confirmation
  Widget _buildConfirmationStep() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Foto yang diambil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Photo Preview
              if (_imageBytes != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      _imageBytes!,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              // Location Info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D5B7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFF4C7F9A),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Lokasi",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isLoadingLocation)
                      const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF4C7F9A),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Mengambil lokasi...",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      )
                    else if (_position != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _address ?? "Mencari alamat...",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "📍 Lat: ${_position!.latitude.toStringAsFixed(6)}, Lng: ${_position!.longitude.toStringAsFixed(6)}",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        "Lokasi belum tersedia",
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isSubmitting || _position == null
                          ? null
                          : _submitAbsen,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF2C3E50),
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text(
                        _isSubmitting ? "Mengirim..." : "Kirim",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8D5B7),
                        foregroundColor: const Color(0xFF2C3E50),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: (_position == null || _isSubmitting)
                                ? null
                                : _copyLocationToClipboard,
                            icon: const Icon(
                              Icons.share,
                              color: Color(0xFF2C3E50),
                            ),
                            label: const Text(
                              'Bagikan Lokasi',
                              style: TextStyle(color: Color(0xFF2C3E50)),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFE8D5B7)),
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: (_position == null || _isSubmitting)
                                ? null
                                : _openLocationInMaps,
                            icon: const Icon(
                              Icons.map,
                              color: Color(0xFF2C3E50),
                            ),
                            label: const Text(
                              'Buka di Maps',
                              style: TextStyle(color: Color(0xFF2C3E50)),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFE8D5B7)),
                              minimumSize: const Size(double.infinity, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              setState(() {
                                _currentStep = 1;
                                _imageBytes = null;
                                _position = null;
                              });
                            },
                      child: const Text(
                        "Ambil Ulang Foto",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Step 4: Success
  Widget _buildSuccessStep() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryColor, _primaryColor.withValues(alpha: 0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFFE8D5B7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Kehadiran Anda Tercatat, Terima\nKasih!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
