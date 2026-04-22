import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class KeuanganPage extends StatefulWidget {
  const KeuanganPage({super.key});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MidtransSDK? _midtrans;

  // Mock Data Tagihan
  final List<Map<String, dynamic>> _tagihanList = [
    {
      "id": "INV-20250101",
      "judul": "Uang Kuliah Tunggal (UKT) - Sem 5",
      "nominal": 4500000,
      "jatuh_tempo": "2025-02-15",
      "status": "Belum Lunas",
      "deskripsi": "Pembayaran UKT Semester Ganjil 2024/2025",
    },
    {
      "id": "INV-20250102",
      "judul": "Biaya Praktikum",
      "nominal": 750000,
      "jatuh_tempo": "2025-02-20",
      "status": "Belum Lunas",
      "deskripsi": "Biaya praktikum laboratorium komputer",
    },
  ];

  // Mock Data Riwayat
  final List<Map<String, dynamic>> _riwayatList = [
    {
      "id": "INV-20240801",
      "judul": "Uang Kuliah Tunggal (UKT) - Sem 4",
      "nominal": 4500000,
      "tanggal_bayar": "2024-08-10",
      "status": "Lunas",
      "metode": "Virtual Account BNI",
    },
    {
      "id": "INV-20240201",
      "judul": "Uang Kuliah Tunggal (UKT) - Sem 3",
      "nominal": 4500000,
      "tanggal_bayar": "2024-02-12",
      "status": "Lunas",
      "metode": "Virtual Account Mandiri",
    },
    {
      "id": "INV-20230801",
      "judul": "Uang Kuliah Tunggal (UKT) - Sem 2",
      "nominal": 4500000,
      "tanggal_bayar": "2023-08-15",
      "status": "Lunas",
      "metode": "Transfer Bank",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initMidtrans();
  }

  Future<void> _initMidtrans() async {
    try {
      _midtrans = await MidtransSDK.init(
        config: MidtransConfig(
          // TODO: Ganti dengan Client Key Sandbox/Production Anda
          clientKey: "SB-Mid-client-XXXXXX", 
          merchantBaseUrl: "https://api.sandbox.midtrans.com/v2/",
          colorTheme: ColorTheme(
            colorPrimary: const Color(0xFF4C7F9A),
            colorPrimaryDark: const Color(0xFF2C3E50),
            colorSecondary: const Color(0xFFE8D5B7),
          ),
        ),
      );

      _midtrans?.setTransactionFinishedCallback((result) {
        debugPrint("Midtrans Transaction Status: ${result.status}");
        if (result.status == 'settlement' || result.status == 'capture') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pembayaran Berhasil! Tagihan Lunas.")),
          );
        } else if (result.status == 'pending') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Menunggu Pembayaran (Pending).")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pembayaran Gagal / Dibatalkan.")),
          );
        }
      });
    } catch (e) {
      debugPrint("Midtrans init error: $e");
    }
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    _tabController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    // Menggunakan format sederhana dulu untuk menghindari masalah locale
    return "Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building KeuanganPage");
    int totalTagihan = _tagihanList.fold(
      0,
      (sum, item) => sum + (item["nominal"] as int),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Keuangan Mahasiswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4C7F9A),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Tagihan Aktif"),
            Tab(text: "Riwayat Pembayaran"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: TAGIHAN
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalCard(totalTagihan),
                const SizedBox(height: 24),
                const Text(
                  "Daftar Tagihan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                if (_tagihanList.isEmpty)
                  _buildEmptyState("Tidak ada tagihan aktif saat ini.")
                else
                  ..._tagihanList.map((item) => _buildTagihanCard(item)),
              ],
            ),
          ),

          // TAB 2: RIWAYAT
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Riwayat Transaksi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                if (_riwayatList.isEmpty)
                  _buildEmptyState("Belum ada riwayat pembayaran.")
                else
                  ..._riwayatList.map((item) => _buildRiwayatCard(item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C7F9A), Color(0xFF6BA3C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C7F9A).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Tagihan Anda",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: total > 0 ? () => _showPaymentDialog(total) : null,
            icon: const Icon(Icons.payment, color: Color(0xFF4C7F9A)),
            label: const Text(
              "Bayar Sekarang",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4C7F9A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Pembayaran
  void _showPaymentDialog(int totalTagihan) {
    String? selectedMethod;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C7F9A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.payment, color: Color(0xFF4C7F9A)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Pilih Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Pembayaran
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C7F9A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Pembayaran:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatCurrency(totalTagihan),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4C7F9A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Pilih Metode:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Virtual Account
                    _buildPaymentMethodTile(
                      icon: Icons.account_balance,
                      title: "Virtual Account",
                      subtitle: "BNI, Mandiri, BCA, BRI",
                      value: "VA",
                      selectedValue: selectedMethod,
                      onChanged: (value) =>
                          setState(() => selectedMethod = value),
                    ),

                    // E-Wallet
                    _buildPaymentMethodTile(
                      icon: Icons.account_balance_wallet,
                      title: "E-Wallet",
                      subtitle: "GoPay, OVO, DANA, ShopeePay",
                      value: "EWALLET",
                      selectedValue: selectedMethod,
                      onChanged: (value) =>
                          setState(() => selectedMethod = value),
                    ),

                    // Transfer Bank
                    _buildPaymentMethodTile(
                      icon: Icons.account_balance_outlined,
                      title: "Transfer Bank",
                      subtitle: "Transfer manual ke rekening kampus",
                      value: "TRANSFER",
                      selectedValue: selectedMethod,
                      onChanged: (value) =>
                          setState(() => selectedMethod = value),
                    ),

                    // Kartu Kredit/Debit
                    _buildPaymentMethodTile(
                      icon: Icons.credit_card,
                      title: "Kartu Kredit/Debit",
                      subtitle: "Visa, Mastercard, JCB",
                      value: "CARD",
                      selectedValue: selectedMethod,
                      onChanged: (value) =>
                          setState(() => selectedMethod = value),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedMethod != null
                      ? () {
                          Navigator.pop(context);
                          _processPayment(selectedMethod!, totalTagihan);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C7F9A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Lanjutkan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget untuk payment method tile
  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = selectedValue == value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFF4C7F9A) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected
            ? const Color(0xFF4C7F9A).withOpacity(0.05)
            : Colors.white,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedValue,
        onChanged: onChanged,
        activeColor: const Color(0xFF4C7F9A),
        title: Row(
          children: [
            Icon(icon, color: const Color(0xFF4C7F9A), size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  // Proses pembayaran
  void _processPayment(String method, int amount) async {
    // Tampilkan loading sebentar
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    // TODO: Panggil API Backend Anda di sini untuk generate Snap Token.
    // Backend Anda harus me-request token ke Midtrans menggunakan Server Key, 
    // lalu me-return token tersebut ke aplikasi Flutter.
    // Contoh: 
    // final response = await Dio().post("https://backend-anda.com/api/get-snap-token", data: {"amount": amount});
    // String snapToken = response.data['token'];

    // Simulasi delay request backend
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context); // Tutup loading

    // Karena ini belum ada backend, kita akan buka simulasi dialog bawaan dulu.
    // Jika backend sudah ada, hapus blok if(true) ini dan jalankan:
    // _midtrans?.startPaymentUiFlow(token: snapToken);
    
    bool hasRealBackend = false; 

    if (hasRealBackend) {
      // String dummyToken = "DUMMY_TOKEN_DARI_BACKEND";
      // _midtrans?.startPaymentUiFlow(token: dummyToken);
    } else {
      String methodName = method == "VA" ? "Virtual Account" 
          : method == "EWALLET" ? "E-Wallet" 
          : method == "TRANSFER" ? "Transfer Bank" 
          : "Kartu Kredit/Debit";

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Simulasi Pembayaran (Midtrans)"),
          content: Text(
            "Anda memilih metode: $methodName.\n\n"
            "Jika backend Midtrans sudah siap, SDK Midtrans akan otomatis terbuka di sini untuk memproses pembayaran Rp ${_formatCurrency(amount)}."
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C7F9A)),
              child: const Text("Mengerti", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTagihanCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  item["status"],
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Jatuh Tempo: ${item['jatuh_tempo']}",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item["judul"],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item["deskripsi"],
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nominal",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                _formatCurrency(item["nominal"]),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C7F9A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, color: Colors.green.shade600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["judul"],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item['tanggal_bayar']} • ${item['metode']}",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency(item["nominal"]),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
