import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class KalenderAkademikPage extends StatefulWidget {
  const KalenderAkademikPage({super.key});

  @override
  State<KalenderAkademikPage> createState() => _KalenderAkademikPageState();
}

class _KalenderAkademikPageState extends State<KalenderAkademikPage>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late TabController _tabController;
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2025, 1, 6): [
      {
        'title': 'Awal Semester Genap',
        'desc': 'Perkuliahan semester genap dimulai untuk semua program.',
        'type': 'academic',
        'location': 'Kampus Utama',
        'time': '08:00 - 17:00',
      },
    ],
    DateTime(2025, 1, 20): [
      {
        'title': 'Batas Akhir Perubahan KRS',
        'desc': 'Deadline untuk melakukan perubahan KRS semester genap.',
        'type': 'registration',
        'location': 'Online - SIMAK',
        'time': '23:59',
      },
    ],
    DateTime(2025, 2, 10): [
      {
        'title': 'Seminar Nasional Teknologi',
        'desc': 'Seminar nasional dengan tema teknologi dan inovasi.',
        'type': 'academic',
        'location': 'Auditorium Kampus',
        'time': '09:00 - 15:00',
      },
    ],
    DateTime(2025, 2, 15): [
      {
        'title': 'Pengisian KRS',
        'desc': 'Mahasiswa melakukan pengisian KRS via sistem SIMAK.',
        'type': 'registration',
        'location': 'Online - SIMAK',
        'time': '00:00 - 23:59',
      },
    ],
    DateTime(2025, 2, 20): [
      {
        'title': 'Batas Akhir Pembayaran UKT',
        'desc': 'Deadline pembayaran UKT semester genap.',
        'type': 'payment',
        'location': 'Bank/Virtual Account',
        'time': '23:59',
      },
    ],
    DateTime(2025, 3, 15): [
      {
        'title': 'Ujian Tengah Semester',
        'desc': 'UTS berlangsung selama satu minggu untuk semua mata kuliah.',
        'type': 'exam',
        'location': 'Ruang Ujian Kampus',
        'time': '08:00 - 16:00',
      },
    ],
    DateTime(2025, 3, 28): [
      {
        'title': 'Hari Raya Nyepi',
        'desc': 'Libur nasional Hari Raya Nyepi.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
    DateTime(2025, 4, 1): [
      {
        'title': 'Libur Paskah',
        'desc': 'Libur nasional, perkuliahan libur.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
    DateTime(2025, 4, 18): [
      {
        'title': 'Workshop Pengembangan Karir',
        'desc':
            'Workshop untuk mahasiswa tingkat akhir tentang persiapan karir.',
        'type': 'academic',
        'location': 'Ruang Seminar Lt. 3',
        'time': '13:00 - 16:00',
      },
    ],
    DateTime(2025, 5, 1): [
      {
        'title': 'Hari Buruh Internasional',
        'desc': 'Libur nasional.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
    DateTime(2025, 5, 15): [
      {
        'title': 'Wisuda Periode Mei 2025',
        'desc': 'Upacara wisuda untuk lulusan periode Februari 2025.',
        'type': 'academic',
        'location': 'Auditorium Utama',
        'time': '09:00 - 14:00',
      },
    ],
    DateTime(2025, 5, 29): [
      {
        'title': 'Kenaikan Isa Almasih',
        'desc': 'Libur nasional.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
    DateTime(2025, 6, 1): [
      {
        'title': 'Hari Lahir Pancasila',
        'desc': 'Peringatan Hari Lahir Pancasila.',
        'type': 'holiday',
        'location': 'Kampus',
        'time': '08:00 - 12:00',
      },
    ],
    DateTime(2025, 6, 10): [
      {
        'title': 'Ujian Akhir Semester',
        'desc': 'UAS berlangsung selama dua minggu.',
        'type': 'exam',
        'location': 'Ruang Ujian Kampus',
        'time': '08:00 - 16:00',
      },
    ],
    DateTime(2025, 6, 25): [
      {
        'title': 'Pengumuman Nilai Semester Genap',
        'desc': 'Pengumuman nilai akhir semester genap.',
        'type': 'academic',
        'location': 'Online - SIMAK',
        'time': '10:00',
      },
    ],
    DateTime(2025, 7, 1): [
      {
        'title': 'Libur Semester Genap',
        'desc': 'Libur semester genap dimulai.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
    DateTime(2025, 7, 15): [
      {
        'title': 'Pendaftaran Mahasiswa Baru',
        'desc': 'Periode pendaftaran mahasiswa baru tahun ajaran 2025/2026.',
        'type': 'registration',
        'location': 'Online & Kampus',
        'time': '08:00 - 16:00',
      },
    ],
    DateTime(2025, 8, 17): [
      {
        'title': 'Hari Kemerdekaan RI',
        'desc': 'Perayaan HUT RI ke-80 dengan upacara bendera.',
        'type': 'holiday',
        'location': 'Lapangan Kampus',
        'time': '08:00 - 12:00',
      },
    ],
    DateTime(2025, 8, 25): [
      {
        'title': 'Orientasi Mahasiswa Baru',
        'desc':
            'Kegiatan orientasi dan pengenalan kampus untuk mahasiswa baru.',
        'type': 'academic',
        'location': 'Kampus Utama',
        'time': '07:00 - 17:00',
      },
    ],
    DateTime(2025, 9, 1): [
      {
        'title': 'Awal Semester Ganjil 2025/2026',
        'desc': 'Perkuliahan semester ganjil dimulai.',
        'type': 'academic',
        'location': 'Kampus Utama',
        'time': '08:00 - 17:00',
      },
    ],
    DateTime(2025, 9, 10): [
      {
        'title': 'Pengisian KRS Semester Ganjil',
        'desc': 'Periode pengisian KRS untuk semester ganjil.',
        'type': 'registration',
        'location': 'Online - SIMAK',
        'time': '00:00 - 23:59',
      },
    ],
    DateTime(2025, 9, 25): [
      {
        'title': 'Batas Pembayaran UKT Semester Ganjil',
        'desc': 'Deadline pembayaran UKT semester ganjil.',
        'type': 'payment',
        'location': 'Bank/Virtual Account',
        'time': '23:59',
      },
    ],
    DateTime(2025, 10, 15): [
      {
        'title': 'Ujian Tengah Semester Ganjil',
        'desc': 'UTS semester ganjil untuk semua mata kuliah.',
        'type': 'exam',
        'location': 'Ruang Ujian Kampus',
        'time': '08:00 - 16:00',
      },
    ],
    DateTime(2025, 10, 28): [
      {
        'title': 'Sumpah Pemuda',
        'desc': 'Peringatan Hari Sumpah Pemuda.',
        'type': 'holiday',
        'location': 'Kampus',
        'time': '08:00 - 12:00',
      },
    ],
    DateTime(2025, 11, 10): [
      {
        'title': 'Hari Pahlawan',
        'desc': 'Peringatan Hari Pahlawan Nasional.',
        'type': 'holiday',
        'location': 'Kampus',
        'time': '08:00 - 12:00',
      },
    ],
    DateTime(2025, 11, 20): [
      {
        'title': 'Job Fair Kampus',
        'desc': 'Bursa kerja untuk mahasiswa dan alumni.',
        'type': 'academic',
        'location': 'Hall Utama Kampus',
        'time': '09:00 - 16:00',
      },
    ],
    DateTime(2025, 12, 1): [
      {
        'title': 'Pendaftaran Wisuda Periode Februari 2026',
        'desc':
            'Pembukaan pendaftaran wisuda untuk lulusan periode Februari 2026.',
        'type': 'registration',
        'location': 'Online - SIMAK',
        'time': '00:00 - 23:59',
      },
    ],
    DateTime(2025, 12, 8): [
      {
        'title': 'Seminar Proposal Skripsi',
        'desc': 'Seminar proposal skripsi untuk mahasiswa tingkat akhir.',
        'type': 'academic',
        'location': 'Ruang Seminar',
        'time': '09:00 - 15:00',
      },
    ],
    DateTime(2025, 12, 15): [
      {
        'title': 'Ujian Akhir Semester Ganjil',
        'desc': 'UAS semester ganjil dimulai.',
        'type': 'exam',
        'location': 'Ruang Ujian Kampus',
        'time': '08:00 - 16:00',
      },
    ],
    DateTime(2025, 12, 25): [
      {
        'title': 'Libur Natal',
        'desc': 'Libur nasional Hari Natal.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
    DateTime(2025, 12, 31): [
      {
        'title': 'Libur Tahun Baru',
        'desc': 'Libur akhir tahun 2025.',
        'type': 'holiday',
        'location': '-',
        'time': 'Sepanjang Hari',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationsPlugin.initialize(initSettings);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  List<MapEntry<DateTime, List<Map<String, String>>>> _getFilteredEvents() {
    var filtered = _events.entries.toList();

    // Filter by category
    if (_selectedFilter != 'all') {
      filtered = filtered
          .map((entry) {
            final filteredList = entry.value
                .where((event) => event['type'] == _selectedFilter)
                .toList();
            return MapEntry(entry.key, filteredList);
          })
          .where((entry) => entry.value.isNotEmpty)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .map((entry) {
            final filteredList = entry.value.where((event) {
              return event['title']!.toLowerCase().contains(_searchQuery) ||
                  event['desc']!.toLowerCase().contains(_searchQuery);
            }).toList();
            return MapEntry(entry.key, filteredList);
          })
          .where((entry) => entry.value.isNotEmpty)
          .toList();
    }

    // Sort by date
    filtered.sort((a, b) => a.key.compareTo(b.key));
    return filtered;
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'academic':
        return const Color(0xFF4C7F9A);
      case 'exam':
        return Colors.red.shade400;
      case 'registration':
        return Colors.orange.shade400;
      case 'payment':
        return Colors.purple.shade400;
      case 'holiday':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'academic':
        return Icons.school_outlined;
      case 'exam':
        return Icons.edit_calendar_outlined;
      case 'registration':
        return Icons.how_to_reg_outlined;
      case 'payment':
        return Icons.account_balance_wallet_outlined;
      case 'holiday':
        return Icons.beach_access_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  String _getEventTypeName(String type) {
    switch (type) {
      case 'academic':
        return 'Akademik';
      case 'exam':
        return 'Ujian';
      case 'registration':
        return 'Pendaftaran';
      case 'payment':
        return 'Pembayaran';
      case 'holiday':
        return 'Libur';
      default:
        return 'Lainnya';
    }
  }

  void _showEventDetail(Map<String, String> event, DateTime date) {
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
            // Handle bar
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
                    // Event Icon & Type
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getEventColor(
                              event['type']!,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getEventIcon(event['type']!),
                            color: _getEventColor(event['type']!),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getEventTypeName(event['type']!),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getEventColor(event['type']!),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event['title']!,
                                style: const TextStyle(
                                  fontSize: 22,
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

                    // Date & Time
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Tanggal',
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.access_time, 'Waktu', event['time']!),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.location_on_outlined,
                      'Lokasi',
                      event['location']!,
                    ),
                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event['desc']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _setReminder(event, date);
                            },
                            icon: const Icon(Icons.notifications_outlined),
                            label: const Text('Set Reminder'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF4C7F9A),
                              side: const BorderSide(color: Color(0xFF4C7F9A)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _addToDeviceCalendar(event, date);
                            },
                            icon: const Icon(Icons.add_to_home_screen),
                            label: const Text('Tambah ke Kalender'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4C7F9A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
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
            color: const Color(0xFF4C7F9A).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF4C7F9A), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 8,
        shadowColor: const Color(0xFF4C7F9A).withValues(alpha: 0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Kalender Akademik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.today, color: Colors.white),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
                _tabController.index = 0;
              });
            },
            tooltip: 'Hari Ini',
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.white),
            onPressed: () {
              _showDownloadOptions();
            },
            tooltip: 'Download',
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
            Tab(text: 'Kalender'),
            Tab(text: 'Daftar Event'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCalendarView(), _buildListView()],
      ),
    );
  }

  Widget _buildCalendarView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C7F9A).withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
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
                        'Kalender Akademik',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tahun Ajaran 2025–2026',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('all', 'Semua', Icons.grid_view),
                _buildFilterChip('academic', 'Akademik', Icons.school_outlined),
                _buildFilterChip('exam', 'Ujian', Icons.edit_calendar_outlined),
                _buildFilterChip(
                  'registration',
                  'Pendaftaran',
                  Icons.how_to_reg_outlined,
                ),
                _buildFilterChip(
                  'payment',
                  'Pembayaran',
                  Icons.account_balance_wallet_outlined,
                ),
                _buildFilterChip(
                  'holiday',
                  'Libur',
                  Icons.beach_access_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Calendar Widget
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime(2025, 1, 1),
              lastDay: DateTime(2026, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF6BA3C0).withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
                  ),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF4C7F9A),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.red),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: const Color(0xFF4C7F9A),
                  borderRadius: BorderRadius.circular(8),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFF4C7F9A),
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF4C7F9A),
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),

          const SizedBox(height: 20),

          // Selected Day Events
          if (_selectedDay != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Event pada ${DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_selectedDay!)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_getEventsForDay(_selectedDay!).isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada event pada tanggal ini',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._getEventsForDay(_selectedDay!).map((event) {
                return _buildEventCard(event, _selectedDay!);
              }),
            const SizedBox(height: 20),
          ],

          // Informasi Terkini
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📋 Informasi Terkini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        Icons.how_to_reg,
                        'Periode Pendaftaran',
                        '01 Sep 2025 - 15 Sep 2025',
                        Colors.orange,
                      ),
                      const Divider(height: 1),
                      _buildInfoTile(
                        Icons.school,
                        'Perkuliahan',
                        'Mulai 20 Sep 2025 - 30 Des 2025',
                        Colors.green,
                      ),
                      const Divider(height: 1),
                      _buildInfoTile(
                        Icons.edit_calendar,
                        'Ujian',
                        '10 Jun 2026 - 24 Jun 2026',
                        const Color(0xFF4C7F9A),
                      ),
                      const Divider(height: 1),
                      _buildInfoTile(
                        Icons.beach_access,
                        'Libur Semester',
                        '25 Des 2025 - 05 Jan 2026',
                        Colors.teal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari event...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF4C7F9A)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip('all', 'Semua', Icons.grid_view),
              _buildFilterChip('academic', 'Akademik', Icons.school_outlined),
              _buildFilterChip('exam', 'Ujian', Icons.edit_calendar_outlined),
              _buildFilterChip(
                'registration',
                'Pendaftaran',
                Icons.how_to_reg_outlined,
              ),
              _buildFilterChip(
                'payment',
                'Pembayaran',
                Icons.account_balance_wallet_outlined,
              ),
              _buildFilterChip('holiday', 'Libur', Icons.beach_access_outlined),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Event List
        Expanded(
          child: _getFilteredEvents().isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada event ditemukan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _getFilteredEvents().length,
                  itemBuilder: (context, index) {
                    final entry = _getFilteredEvents()[index];
                    final date = entry.key;
                    final events = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Header
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4C7F9A,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  DateFormat(
                                    'EEEE, dd MMM yyyy',
                                    'id_ID',
                                  ).format(date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4C7F9A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Events for this date
                        ...events.map((event) => _buildEventCard(event, date)),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF4C7F9A),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedColor: const Color(0xFF4C7F9A),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF4C7F9A),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF4C7F9A)
                : const Color(0xFF4C7F9A).withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event, DateTime date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _showEventDetail(event, date),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getEventColor(event['type']!).withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getEventColor(
                      event['type']!,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getEventIcon(event['type']!),
                    color: _getEventColor(event['type']!),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event['desc']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event['time']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // PDF Generation Feature
  Future<void> _generatePDF() async {
    if (!await _requestStoragePermission()) {
      return;
    }

    try {
      final pdf = pw.Document();

      // Get all events sorted by date
      final sortedEvents = _events.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Helper function to format date without locale
      String formatDate(DateTime date) {
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Kalender Akademik 2025-2026',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Universitas - Sistem Informasi Akademik',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 20),
            ...sortedEvents.expand((entry) {
              final date = entry.key;
              final events = entry.value;
              return [
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Text(
                    formatDate(date),
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                ...events.map(
                  (event) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 15),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          event['title']!,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text('Jenis: ${_getEventTypeName(event['type']!)}'),
                        pw.Text('Waktu: ${event['time']}'),
                        pw.Text('Lokasi: ${event['location']}'),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          event['desc']!,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            }),
          ],
        ),
      );

      // Save PDF to device Downloads folder
      final fileName =
          'kalender_akademik_2025_2026_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final bytes = await pdf.save();

      // Handle Web Platform
      if (kIsWeb) {
        await Printing.sharePdf(bytes: bytes, filename: fileName);
        return;
      }

      // Handle Mobile Platform
      try {
        Directory? directory;
        String folderName = 'Download';

        if (Platform.isAndroid) {
          // Try multiple paths for Android
          final List<String> possiblePaths = [
            '/storage/emulated/0/Download',
            '/storage/emulated/0/Downloads',
          ];

          bool foundPath = false;
          for (String path in possiblePaths) {
            try {
              directory = Directory(path);
              if (await directory.exists()) {
                foundPath = true;
                break;
              }
            } catch (_) {}
          }

          // Fallback to app-specific external storage
          if (!foundPath) {
            try {
              final externalDir = await getExternalStorageDirectory();
              if (externalDir != null) {
                directory = Directory('${externalDir.path}/Downloads');
                if (!await directory.exists()) {
                  await directory.create(recursive: true);
                }
                folderName = directory.path;
              }
            } catch (_) {}
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
          folderName = directory.path;
        }

        directory ??= await getApplicationDocumentsDirectory();

        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF berhasil disimpan di $folderName'),
              backgroundColor: const Color(0xFF4C7F9A),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'BUKA',
                textColor: Colors.white,
                onPressed: () {
                  OpenFile.open(file.path);
                },
              ),
            ),
          );
        }

        // Open the PDF
        await OpenFile.open(file.path);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mencoba metode alternatif...')),
          );
        }
        // Fallback sharing if direct save fails
        await Printing.sharePdf(bytes: bytes, filename: fileName);
      }
    } catch (e) {
      // Global error handler for PDF generation
      debugPrint('Error generating PDF: $e');
    }
  }

  // Excel Export Feature
  Future<void> _exportToExcel() async {
    // Permission check for Mobile only
    if (!kIsWeb && !await _requestStoragePermission()) {
      return;
    }

    try {
      final excel = excel_lib.Excel.createExcel();
      final sheet = excel['Kalender Akademik'];

      // Add headers
      sheet.appendRow([
        excel_lib.TextCellValue('Tanggal'),
        excel_lib.TextCellValue('Judul Event'),
        excel_lib.TextCellValue('Jenis'),
        excel_lib.TextCellValue('Waktu'),
        excel_lib.TextCellValue('Lokasi'),
        excel_lib.TextCellValue('Deskripsi'),
      ]);

      // Style headers
      for (var i = 0; i < 6; i++) {
        final cell = sheet.cell(
          excel_lib.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.cellStyle = excel_lib.CellStyle(
          bold: true,
          backgroundColorHex: excel_lib.ExcelColor.blue,
        );
      }

      // Add data
      final sortedEvents = _events.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      for (final entry in sortedEvents) {
        final date = entry.key;
        for (final event in entry.value) {
          sheet.appendRow([
            excel_lib.TextCellValue(
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
            ),
            excel_lib.TextCellValue(event['title']!),
            excel_lib.TextCellValue(_getEventTypeName(event['type']!)),
            excel_lib.TextCellValue(event['time']!),
            excel_lib.TextCellValue(event['location']!),
            excel_lib.TextCellValue(event['desc']!),
          ]);
        }
      }

      // Save Excel file
      final fileName =
          'kalender_akademik_2025_2026_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final excelBytes = excel.encode();

      if (excelBytes == null) {
        throw Exception('Gagal meng-encode Excel');
      }

      // Handle Web Platform
      if (kIsWeb) {
        await Printing.sharePdf(
          bytes: Uint8List.fromList(excelBytes),
          filename: fileName,
        );
        return;
      }

      // Handle Mobile Platform - Save to Downloads folder
      Directory? directory;
      try {
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
          // Fallback
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        directory = await getApplicationDocumentsDirectory();
      }

      final file = File('${directory!.path}/$fileName');
      // Already encoded above

      await file.writeAsBytes(excelBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Excel berhasil disimpan di ${file.path}'),
            backgroundColor: const Color(0xFF4C7F9A),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'BUKA',
              textColor: Colors.white,
              onPressed: () {
                OpenFile.open(file.path);
              },
            ),
          ),
        );
      }

      // Open the Excel file
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat Excel: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Permission Helper
  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Check if we can write to storage
    // For specific Android versions, we might need different permissions
    // Android 13+ (API 33+)
    // Uses photos, videos, audio permissions for reading, but writing to public directory like Documents/Downloads
    // might require nothing if using proper API, or just simple file IO if supported.
    // However, permission_handler maps storage to READ_EXTERNAL_STORAGE/WRITE_EXTERNAL_STORAGE
    // which are deprecated or limited in 13+

    // Simple robust check:
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    // Request permission
    status = await Permission.storage.request();

    if (status.isGranted) {
      return true;
    }

    // If denied, try photos (sometimes used as proxy for "storage" in improper setups or just to get Read access)
    // But for Downloads, let's try to notify user.
    if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Izin Diperlukan'),
            content: const Text(
              'Aplikasi memerlukan izin penyimpanan untuk menyimpan file kalender. Silakan aktifkan di pengaturan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
      }
      return false;
    }

    return status.isGranted;
  }

  // Add to Device Calendar Feature
  Future<void> _addToDeviceCalendar(
    Map<String, String> eventData,
    DateTime date,
  ) async {
    try {
      // Parse time
      final timeStr = eventData['time']!;
      DateTime startTime = date;
      DateTime endTime = date.add(const Duration(hours: 1));

      // Try to parse time if it's in format "HH:mm - HH:mm"
      if (timeStr.contains('-') && timeStr.contains(':')) {
        final times = timeStr.split('-');
        if (times.length == 2) {
          final startParts = times[0].trim().split(':');
          if (startParts.length == 2) {
            startTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.tryParse(startParts[0]) ?? 8,
              int.tryParse(startParts[1]) ?? 0,
            );
          }
          final endParts = times[1].trim().split(':');
          if (endParts.length == 2) {
            endTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.tryParse(endParts[0]) ?? 9,
              int.tryParse(endParts[1]) ?? 0,
            );
          }
        }
      }

      final Event event = Event(
        title: eventData['title']!,
        description: eventData['desc']!,
        location: eventData['location']!,
        startDate: startTime,
        endDate: endTime,
        allDay: timeStr.toLowerCase().contains('sepanjang hari'),
      );

      final result = await Add2Calendar.addEvent2Cal(event);

      if (mounted) {
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event berhasil ditambahkan ke kalender'),
              backgroundColor: Color(0xFF4C7F9A),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan event ke kalender'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Sync All Events to Calendar
  Future<void> _syncAllEventsToCalendar() async {
    try {
      int successCount = 0;
      for (final entry in _events.entries) {
        for (final event in entry.value) {
          await _addToDeviceCalendar(event, entry.key);
          successCount++;
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$successCount event berhasil disinkronkan'),
            backgroundColor: const Color(0xFF4C7F9A),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal sinkronisasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Set Reminder Feature
  Future<void> _setReminder(
    Map<String, String> eventData,
    DateTime date,
  ) async {
    try {
      // Request notification permission
      final status = await Permission.notification.request();

      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Izin notifikasi diperlukan untuk mengatur reminder',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Schedule notification 1 day before the event
      final reminderDate = date.subtract(const Duration(days: 1));

      // Only schedule if the reminder date is in the future
      if (reminderDate.isAfter(DateTime.now())) {
        const androidDetails = AndroidNotificationDetails(
          'kalender_akademik',
          'Kalender Akademik',
          channelDescription: 'Reminder untuk event akademik',
          importance: Importance.high,
          priority: Priority.high,
        );

        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        // Use a unique ID based on the event title and date
        final notificationId =
            '${eventData['title']}_${date.millisecondsSinceEpoch}'.hashCode;

        await _notificationsPlugin.show(
          notificationId,
          'Reminder: ${eventData['title']}',
          'Event besok: ${DateFormat('dd MMMM yyyy', 'id_ID').format(date)}',
          notificationDetails,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Reminder diatur untuk ${DateFormat('dd MMM yyyy', 'id_ID').format(reminderDate)}',
              ),
              backgroundColor: const Color(0xFF4C7F9A),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event sudah terlalu dekat atau sudah lewat'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengatur reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Color(0xFF2C3E50),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
    );
  }

  void _showDownloadOptions() {
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
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Download Kalender Akademik',
                style: TextStyle(
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
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red),
              ),
              title: const Text('Kalender Akademik 2025-2026'),
              subtitle: const Text('PDF Format - 2.5 MB'),
              trailing: const Icon(Icons.download, color: Color(0xFF4C7F9A)),
              onTap: () {
                Navigator.pop(context);
                _generatePDF();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.table_chart, color: Colors.green),
              ),
              title: const Text('Export ke Excel'),
              subtitle: const Text('XLSX Format'),
              trailing: const Icon(Icons.download, color: Color(0xFF4C7F9A)),
              onTap: () {
                Navigator.pop(context);
                _exportToExcel();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_today, color: Colors.blue),
              ),
              title: const Text('Sinkronisasi dengan Google Calendar'),
              subtitle: const Text('Otomatis update'),
              trailing: const Icon(Icons.sync, color: Color(0xFF4C7F9A)),
              onTap: () {
                Navigator.pop(context);
                _syncAllEventsToCalendar();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
