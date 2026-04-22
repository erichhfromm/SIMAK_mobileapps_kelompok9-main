import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> newsList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    // Simulasi loading data
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      newsList = [
        {
          "title": "Pembukaan Pendaftaran Wisuda Semester Ganjil",
          "date": "08 Des 2025",
          "category": "Akademik",
          "description": "Pendaftaran wisuda semester ganjil resmi dibuka mulai hari ini hingga 30 Januari 2026. Segera lengkapi berkas Anda.",
          "content": "Pendaftaran wisuda semester ganjil tahun akademik 2025/2026 telah resmi dibuka. Mahasiswa tingkat akhir yang telah menyelesaikan seluruh kewajiban akademik diharapkan segera melakukan pendaftaran melalui portal akademik. Batas akhir pendaftaran dan penyerahan berkas adalah tanggal 30 Januari 2026.",
          "urlToImage": "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=800&q=70",
        },
        {
          "title": "Seminar Nasional Teknologi Informasi 2025",
          "date": "05 Des 2025",
          "category": "Event",
          "description": "Seminar nasional dengan tema 'AI for Future' dibuka untuk seluruh mahasiswa aktif secara gratis.",
          "content": "Himpunan Mahasiswa Teknik Informatika akan menyelenggarakan Seminar Nasional Teknologi Informasi dengan tema 'Artificial Intelligence for Future'. Acara ini akan diadakan pada tanggal 20 Februari 2026 di Auditorium Utama. Menghadirkan pembicara dari praktisi industri teknologi terkemuka. Pendaftaran gratis bagi mahasiswa aktif.",
          "urlToImage": "https://images.unsplash.com/photo-1544531586-fde5298cdd40?auto=format&fit=crop&w=800&q=70",
        },
        {
          "title": "Beasiswa Prestasi Dibuka Kembali",
          "date": "01 Des 2025",
          "category": "Beasiswa",
          "description": "Program beasiswa prestasi untuk mahasiswa dengan IPK > 3.50 kembali dibuka hingga akhir Februari.",
          "content": "Kabar gembira bagi mahasiswa berprestasi! Program Beasiswa Prestasi Yayasan kembali dibuka untuk Semester Genap. Syarat utama adalah memiliki IPK minimal 3.50 dan aktif dalam kegiatan organisasi kemahasiswaan. Pendaftaran dapat dilakukan secara online melalui menu Beasiswa di aplikasi SIMAK.",
          "urlToImage": "https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=800&q=70",
        },
        {
           "title": "Jadwal Libur Semester Ganjil",
           "date": "28 Nov 2025",
           "category": "Pengumuman",
           "description": "Libur semester ganjil dimulai tanggal 20 Desember 2025 sampai 15 Januari 2026.",
           "content": "Berdasarkan kalender akademik, libur semester ganjil akan dimulai pada tanggal 20 Desember 2025 dan berakhir pada 15 Januari 2026. Perkuliahan semester genap akan dimulai efektif pada tanggal 20 Januari 2026. Mahasiswa diimbau untuk menyelesaikan administrasi registrasi ulang sebelum masa perkuliahan dimulai.",
           "urlToImage": "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=800&q=70",
        }
      ];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Grayish Blue background
      appBar: AppBar(
        title: const Text(
          "Berita Kampus",
           style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF4C7F9A), // Consistent Blue Color
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final item = newsList[index];
                return _buildNewsCard(item);
              },
            ),
    );
  }

  Widget _buildNewsCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(data: item),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  item["urlToImage"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Date Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4C7F9A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item["category"] ?? "Umum",
                            style: const TextStyle(
                              color: Color(0xFF4C7F9A),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          item["date"] ?? "",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Title
                    Text(
                      item["title"] ?? "Tanpa Judul",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      item["description"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final dynamic data;
  const NewsDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF4C7F9A),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                data["urlToImage"],
                fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey)),
                  ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Metadata
                  Row(
                    children: [
                       Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4C7F9A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data["category"] ?? "Berita",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          data["date"] ?? "",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    data["title"] ?? "Tanpa Judul",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Content
                  Text(
                    data["content"] ?? data["description"] ?? "Konten tidak tersedia",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
