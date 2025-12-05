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
    // OFFLINE VERSION — langsung isi data dummy
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      newsList = [
        {
          "title": "Pembukaan Pendaftaran Wisuda Semester Ganjil",
          "description": "Pendaftaran wisuda semester ganjil resmi dibuka sampai 30 Januari.",
          "content": "Pendaftaran wisuda semester ganjil resmi dibuka. Mahasiswa dapat melakukan pendaftaran melalui portal akademik hingga tanggal 30 Januari.",
          "urlToImage": "https://images.unsplash.com/photo-1529070538774-1843cb3265df?auto=format&fit=crop&w=800&q=60",
        },
        {
          "title": "Seminar Nasional Teknologi Informasi 2025",
          "description": "Seminar nasional dibuka untuk seluruh mahasiswa aktif.",
          "content": "Seminar Nasional Teknologi Informasi akan diselenggarakan pada tanggal 20 Februari dan terbuka bagi seluruh mahasiswa.",
          "urlToImage": "https://images.unsplash.com/photo-1515169067865-5387ec356754?auto=format&fit=crop&w=800&q=60",
        },
        {
          "title": "Beasiswa Prestasi Dibuka Kembali",
          "description": "Program beasiswa prestasi dibuka hingga akhir Februari.",
          "content": "Program Beasiswa Prestasi kembali dibuka. Mahasiswa dapat mendaftar dengan melampirkan persyaratan yang telah ditentukan.",
          "urlToImage": "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&w=800&q=60",
        }
      ];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Kampus"),
        backgroundColor: Colors.indigo,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final item = newsList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
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
                        if (item["urlToImage"] != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              item["urlToImage"],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"] ?? "Tanpa Judul",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item["description"] ?? "Tidak ada deskripsi",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
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
      appBar: AppBar(
        title: const Text("Detail Berita"),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (data["urlToImage"] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                data["urlToImage"],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            data["title"] ?? "Tanpa Judul",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            data["content"] ?? data["description"] ?? "Konten tidak tersedia",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
