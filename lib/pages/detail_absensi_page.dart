import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../api/api_service.dart';

class DetailAbsensiPage extends StatefulWidget {
  final int idKrsDetail;
  final int pertemuan;
  final String namaMatkul;

  const DetailAbsensiPage({
    super.key,
    required this.idKrsDetail,
    required this.pertemuan,
    required this.namaMatkul,
  });

  @override
  State<DetailAbsensiPage> createState() => _DetailAbsensiPageState();
}

class _DetailAbsensiPageState extends State<DetailAbsensiPage> {
  bool isLoading = true;
  Map<String, dynamic>? data;
  String? mapViewType;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      Dio dio = Dio();
      final url =
          "${ApiService.baseUrl}absensi/detail?id_krs_detail=${widget.idKrsDetail}&pertemuan=${widget.pertemuan}";

      final res = await dio.get(url);
      data = res.data["data"];

      if (data == null) throw Exception("Data null");

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Demo mode: Using dummy detail in DetailAbsensiPage");
      setState(() {
        data = {
          "pertemuan": widget.pertemuan,
          "latitude": -8.219238,
          "longitude": 114.369227,
          "foto": "https://api.dicebear.com/7.x/avataaars/png?seed=demo",
          "created_at": "2025-01-10 08:30:12",
        };
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7EE),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF4C7F9A),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Detail Absensi - ${widget.namaMatkul} (P.${widget.pertemuan})",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4C7F9A)),
            )
          : data == null
          ? const Center(
              child: Text(
                "Belum ada data absensi.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4C7F9A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ============================
                  ///      FOTO ABSENSI
                  /// ============================
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "${data!['foto']}",
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        height: 240,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Color(0xFF4C7F9A),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ============================
                  ///    DETAIL INFORMASI
                  /// ============================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Pertemuan", "${data!['pertemuan']}"),
                        _buildDetailRow("Latitude", "${data!['latitude']}"),
                        _buildDetailRow("Longitude", "${data!['longitude']}"),
                        _buildDetailRow(
                          "Waktu",
                          "${data!['created_at'] ?? '-'}",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Lokasi pada Peta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C7F9A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// ============================
                  ///         MAP VIEW
                  /// ============================
                  if (mapViewType != null)
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: HtmlElementView(viewType: mapViewType!),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF4C7F9A),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
