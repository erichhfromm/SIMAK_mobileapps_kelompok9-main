import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../api/api_service.dart';

class BimbinganAkademikPage extends StatefulWidget {
  const BimbinganAkademikPage({super.key});

  @override
  State<BimbinganAkademikPage> createState() => _BimbinganAkademikPageState();
}

class _BimbinganAkademikPageState extends State<BimbinganAkademikPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = true;

  // Enhanced data model with status
  final List<Map<String, dynamic>> _guidanceHistory = [
    {
      'no': 1,
      'date': DateTime(2025, 2, 15, 10, 11),
      'topic': 'Peminatan Mata Kuliah',
      'note':
          'Peminatan Matakuliah, PBO, RPL, SBDL, KRIPTO, SPK, KECERDASAN BUATAN, PBR',
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
    {
      'no': 2,
      'date': DateTime(2024, 8, 14, 10, 29),
      'topic': 'Pengambilan Mata Kuliah Semester',
      'note':
          'MHS MENGAMBIL MATAKULIAH SESUAI SEMESTER DESKTOP PROGRAMMING 4 WEB PROGRAMMING 4 JARINGAN KOMPUTER 3 KONSEP PERANGKAT KERAS 3 KEWIRAUSAHAAN 2 SISTEM INFORMASI MANAJEMEN 2 TEORI BAHASA DAN AUTOMATA 3 LOGIKA FUZZY 2 TOTAL SKS 23',
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
    {
      'no': 3,
      'date': DateTime(2024, 2, 22, 11, 36),
      'topic': 'Konsultasi Peminatan',
      'note': 'Mengambil sesuai peminatan yang terlihat di aplikasi',
      'status': 'Selesai',
      'statusColor': Colors.green,
    },
  ];

  final Map<String, String> _dosenPA = {
    'name': 'JOKO PURNOMO M.Kom',
    'email': 'joko.purnomo@university.ac.id',
    'phone': '+62 812-3456-7890',
  };

  Map<String, String> _mahasiswa = {
    'name': 'Loading...',
    'nim': 'Loading...',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  // Helper function to format date in Indonesian
  String _formatDateIndonesian(DateTime date) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final dayName = days[date.weekday % 7];
    final day = date.day.toString().padLeft(2, '0');
    final monthName = months[date.month - 1];
    final year = date.year;
    
    return '$dayName, $day $monthName $year';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('auth_email');

      if (token == null || email == null) {
        setState(() {
          _mahasiswa = {
            'name': 'User tidak ditemukan',
            'nim': '-',
          };
          _isLoading = false;
        });
        return;
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );

      if (response.data['status'] == 200 && response.data['data'] != null) {
        final userData = response.data['data'];
        setState(() {
          _mahasiswa = {
            'name': userData['nama']?.toString().toUpperCase() ?? 'Mahasiswa',
            'nim': userData['nim']?.toString() ?? '-',
          };
          _isLoading = false;
        });
        // Load guidance history after user data is loaded
        await _loadGuidanceHistory();
      } else {
        setState(() {
          _mahasiswa = {
            'name': 'Data tidak tersedia',
            'nim': '-',
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _mahasiswa = {
          'name': 'Error memuat data',
          'nim': '-',
        };
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadGuidanceHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('guidance_history_${_mahasiswa['nim']}');
      
      if (historyJson != null) {
        final List<dynamic> decoded = json.decode(historyJson);
        setState(() {
          _guidanceHistory.clear();
          _guidanceHistory.addAll(decoded.map((item) {
            return {
              'no': item['no'],
              'date': DateTime.parse(item['date']),
              'topic': item['topic'],
              'note': item['note'],
              'status': item['status'],
              'statusColor': _getColorFromString(item['statusColor']),
            };
          }).toList());
        });
      }
    } catch (e) {
      print('Error loading guidance history: $e');
    }
  }

  Future<void> _saveGuidanceHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(_guidanceHistory.map((item) {
        return {
          'no': item['no'],
          'date': (item['date'] as DateTime).toIso8601String(),
          'topic': item['topic'],
          'note': item['note'],
          'status': item['status'],
          'statusColor': _colorToString(item['statusColor'] as Color),
        };
      }).toList());
      
      await prefs.setString('guidance_history_${_mahasiswa['nim']}', historyJson);
    } catch (e) {
      print('Error saving guidance history: $e');
    }
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _colorToString(Color color) {
    if (color == Colors.green) return 'green';
    if (color == Colors.orange) return 'orange';
    if (color == Colors.red) return 'red';
    if (color == Colors.blue) return 'blue';
    return 'grey';
  }

  void _submitNewGuidance() {
    if (_topicController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _guidanceHistory.insert(0, {
        'no': _guidanceHistory.length + 1,
        'date': _selectedDate ?? DateTime.now(),
        'topic': _topicController.text,
        'note': _descriptionController.text,
        'status': 'Menunggu',
        'statusColor': Colors.orange,
      });
    });

    _saveGuidanceHistory();

    _topicController.clear();
    _descriptionController.clear();
    _selectedDate = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengajuan bimbingan berhasil dikirim'),
        backgroundColor: const Color(0xFF4C7F9A),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: () {
            _tabController.animateTo(0);
          },
        ),
      ),
    );

    _tabController.animateTo(0);
  }

  void _editGuidance(int index) {
    final item = _guidanceHistory[index];
    
    _topicController.text = item['topic'];
    _descriptionController.text = item['note'];
    _selectedDate = item['date'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Bimbingan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topik',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _topicController.clear();
              _descriptionController.clear();
              _selectedDate = null;
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _guidanceHistory[index]['topic'] = _topicController.text;
                _guidanceHistory[index]['note'] = _descriptionController.text;
              });
              _saveGuidanceHistory();
              _topicController.clear();
              _descriptionController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bimbingan berhasil diupdate'),
                  backgroundColor: Color(0xFF4C7F9A),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C7F9A),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteGuidance(int index) {
    final item = _guidanceHistory[index];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Bimbingan'),
        content: Text('Apakah Anda yakin ingin menghapus "${item['topic']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _guidanceHistory.removeAt(index);
                // Reorder numbers
                for (int i = 0; i < _guidanceHistory.length; i++) {
                  _guidanceHistory[i]['no'] = i + 1;
                }
              });
              _saveGuidanceHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bimbingan berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _changeStatus(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.hourglass_empty, color: Colors.orange),
              title: const Text('Menunggu'),
              onTap: () {
                setState(() {
                  _guidanceHistory[index]['status'] = 'Menunggu';
                  _guidanceHistory[index]['statusColor'] = Colors.orange;
                });
                _saveGuidanceHistory();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: const Text('Diproses'),
              onTap: () {
                setState(() {
                  _guidanceHistory[index]['status'] = 'Diproses';
                  _guidanceHistory[index]['statusColor'] = Colors.blue;
                });
                _saveGuidanceHistory();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Selesai'),
              onTap: () {
                setState(() {
                  _guidanceHistory[index]['status'] = 'Selesai';
                  _guidanceHistory[index]['statusColor'] = Colors.green;
                });
                _saveGuidanceHistory();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Dibatalkan'),
              onTap: () {
                setState(() {
                  _guidanceHistory[index]['status'] = 'Dibatalkan';
                  _guidanceHistory[index]['statusColor'] = Colors.red;
                });
                _saveGuidanceHistory();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGuidanceDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (item['statusColor'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school,
                            color: item['statusColor'],
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: item['statusColor'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['status'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['topic'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Tanggal',
                      _formatDateIndonesian(item['date']),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.access_time,
                      'Waktu',
                      _formatTime(item['date']),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Catatan Bimbingan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['note'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4C7F9A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4C7F9A),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Hubungi ${_dosenPA['name']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.email, color: Colors.blue),
              ),
              title: const Text('Email'),
              subtitle: Text(_dosenPA['email']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Membuka email ke ${_dosenPA['email']}'),
                    backgroundColor: const Color(0xFF4C7F9A),
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.phone, color: Colors.green),
              ),
              title: const Text('Telepon'),
              subtitle: Text(_dosenPA['phone']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Menghubungi ${_dosenPA['phone']}'),
                    backgroundColor: const Color(0xFF4C7F9A),
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.chat, color: Colors.purple),
              ),
              title: const Text('Chat'),
              subtitle: const Text('Kirim pesan langsung'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur chat akan segera tersedia'),
                    backgroundColor: Color(0xFF4C7F9A),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 8,
        shadowColor: const Color(0xFF4C7F9A).withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Bimbingan Akademik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.contact_phone, color: Colors.white),
            onPressed: _showContactOptions,
            tooltip: 'Hubungi Dosen PA',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          tabs: const [
            Tab(text: 'Riwayat Bimbingan'),
            Tab(text: 'Ajukan Bimbingan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(primary),
          _buildNewRequestTab(primary),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(Color primary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Dosen Pembimbing Akademik',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.school, 'Dosen PA', _dosenPA['name']!),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, 'Mahasiswa', _mahasiswa['name']!),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.badge, 'NIM', _mahasiswa['nim']!),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // History Header
          Row(
            children: [
              const Icon(Icons.history, color: Color(0xFF4C7F9A)),
              const SizedBox(width: 8),
              const Text(
                'Riwayat Bimbingan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_guidanceHistory.length} Catatan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // History List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _guidanceHistory.length,
            itemBuilder: (context, index) {
              final item = _guidanceHistory[index];
              return _buildHistoryCard(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final index = _guidanceHistory.indexOf(item);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (item['statusColor'] as Color).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => _showGuidanceDetail(item),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (item['statusColor'] as Color).withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['statusColor'],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${item['no']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['topic'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['statusColor'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDateIndonesian(item['date']),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(item['date']),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Catatan:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['note'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showGuidanceDetail(item),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Detail'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4C7F9A),
                          side: const BorderSide(color: Color(0xFF4C7F9A)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _changeStatus(index),
                        icon: const Icon(Icons.edit_note, size: 16),
                        label: const Text('Status'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _editGuidance(index),
                      icon: const Icon(Icons.edit, size: 18),
                      color: Colors.orange,
                      tooltip: 'Edit',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _deleteGuidance(index),
                      icon: const Icon(Icons.delete, size: 18),
                      color: Colors.red,
                      tooltip: 'Hapus',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewRequestTab(Color primary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengajuan Bimbingan Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Isi form di bawah untuk mengajukan bimbingan',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Form
          const Text(
            'Topik Bimbingan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _topicController,
            decoration: InputDecoration(
              hintText: 'Contoh: Konsultasi KRS Semester Genap',
              prefixIcon: Icon(Icons.topic, color: primary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Deskripsi / Pertanyaan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Jelaskan detail yang ingin Anda konsultasikan...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Tanggal Preferensi (Opsional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: primary),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate == null
                        ? 'Pilih tanggal'
                        : _formatDateIndonesian(_selectedDate!),
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedDate == null
                          ? Colors.grey.shade600
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitNewGuidance,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 8),
                  Text(
                    'Kirim Pengajuan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pengajuan akan diproses oleh Dosen PA dalam 1-2 hari kerja. Anda akan mendapat notifikasi melalui email.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
