import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_service.dart';
import 'camera_interface.dart';
import 'camera_factory.dart';
import 'face_detection/face_detector_interface.dart';
import 'face_detection/face_detector_factory.dart';

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
  int _currentStep = 1; // 0: QR Scan (removed), 1: Upload Foto, 2: Konfirmasi, 3: Success

  // Data
  Uint8List? _imageBytes;
  Position? _position;
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

      final Uint8List data = await _cam!.capture();
      setState(() {
        _imageBytes = data;
        _currentStep = 2; // Move to confirmation step
      });

      // Auto get location after photo
      await _getLocation();
    } catch (e) {
      debugPrint("Capture error: $e");
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
          setState(() {
            _imageBytes = file.bytes;
            _currentStep = 2; // move to confirmation
          });

          // try to get location after picking
          await _getLocation();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal membaca file gambar")),
          );
        }
      }
    } catch (e) {
      debugPrint("File pick error: $e");
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Lokasi tidak aktif")));
        return;
      }

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin lokasi ditolak permanen")),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() => _position = pos);
    } catch (e) {
      debugPrint("Location error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil lokasi")));
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _copyLocationToClipboard() async {
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi belum tersedia')),
      );
      return;
    }

    final text = 'Lokasi saya: https://www.google.com/maps/search/?api=1&query=${_position!.latitude},${_position!.longitude}';
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tautan lokasi disalin ke clipboard')),
    );
  }

  Future<void> _openLocationInMaps() async {
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi belum tersedia')),
      );
      return;
    }

    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${_position!.latitude},${_position!.longitude}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
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
      bool hasFace = await _faceDetector.hasFace(_imageBytes!);
      if (!hasFace) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wajah tidak terdeteksi pada foto. Silakan foto ulang!")),
          );
        }
        setState(() => _isSubmitting = false);
        return;
      }

      // 2. Validasi Geofencing (Jarak)
      // Koordinat default kampus (Ganti dengan koordinat kampus Anda)
      const double targetLat = -8.219238;
      const double targetLng = 114.369227;
      const double maxDistanceMeters = 5000.0; // 5 KM untuk testing (bisa diganti misal 100.0)

      double distance = Geolocator.distanceBetween(
        _position!.latitude,
        _position!.longitude,
        targetLat,
        targetLng,
      );

      if (distance > maxDistanceMeters) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Jarak Anda terlalu jauh dari kampus (${distance.toInt()} meter).")),
          );
        }
        setState(() => _isSubmitting = false);
        return;
      }

      Dio dio = Dio();

      final form = FormData.fromMap({
        "id_krs_detail": widget.idKrsDetail,
        "pertemuan": widget.pertemuan,
        "latitude": _position!.latitude,
        "longitude": _position!.longitude,
        "foto": MultipartFile.fromBytes(
          _imageBytes!,
          filename: "absen_${DateTime.now().millisecondsSinceEpoch}.png",
        ),
      });

      await dio.post("${ApiService.baseUrl}absensi/submit", data: form);

      setState(() => _currentStep = 3); // Success step

      // Auto close after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context, true);
      });
    } catch (e) {
      debugPrint("Submit error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal submit absen")));
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
    switch (_currentStep) {
      case 0:
        return _buildQRScanStep();
      case 1:
        return _buildUploadPhotoStep();
      case 2:
        return _buildConfirmationStep();
      case 3:
        return _buildSuccessStep();
      default:
        return _buildQRScanStep();
    }
  }

  // Step 1: QR Scan
  Widget _buildQRScanStep() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
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
          colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
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
                          icon: const Icon(Icons.upload_file, color: Color(0xFF2C3E50)),
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
          colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
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
                        color: Colors.black.withOpacity(0.3),
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
                      Text(
                        "📍 Jl. Raya Kelompok Sembung, Banyuwangi 68416",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
                            icon: const Icon(Icons.share, color: Color(0xFF2C3E50)),
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
                            icon: const Icon(Icons.map, color: Color(0xFF2C3E50)),
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
          colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
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
