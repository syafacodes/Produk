import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:produk_app/models/api.dart';
import 'package:produk_app/models/produk.dart';
import 'package:produk_app/ui/dashboard_stats.dart';
import 'package:produk_app/ui/produk_detail.dart';
import 'package:produk_app/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  
  List<Produk> _allProduk = [];
  List<Produk> _foundProduk = [];
  bool _isLoading = true;
  bool _showChart = false;

  // Palet Warna Enterprise
  final Color _primaryColor = const Color(0xFF1A237E); // Deep Indigo
  final Color _accentColor = const Color(0xFFFFA000);  // Amber Accent

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  Future<void> _fetchProduk() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(BaseUrl.list));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Produk> data = jsonResponse.map((e) => Produk.fromJson(e)).toList();
        setState(() {
          _allProduk = data;
          _foundProduk = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _runFilter(String keyword) {
    List<Produk> results = [];
    if (keyword.isEmpty) {
      results = _allProduk;
    } else {
      results = _allProduk
          .where((item) =>
              item.nama!.toLowerCase().contains(keyword.toLowerCase()) ||
              item.kode!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() => _foundProduk = results);
  }

  Future<void> _createPdf() async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text("Laporan Stok Produk", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
                cellAlignment: pw.Alignment.centerLeft,
                headers: <String>['Kode', 'Nama Produk', 'Harga'],
                data: _allProduk.map((item) => [
                  item.kode, 
                  item.nama, 
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.harga)
                ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Footer(title: pw.Text("Dicetak pada: ${DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now())}")),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Dashboard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_showChart ? Icons.view_list_rounded : Icons.pie_chart_rounded, color: Colors.white), 
            onPressed: () => setState(() => _showChart = !_showChart),
            tooltip: "Ganti Tampilan",
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // 1. BACKGROUND HEADER MELENGKUNG
          Container(
            height: 230,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))
              ],
            ),
          ),

          // 2. KONTEN UTAMA
          Column(
            children: [
              const SizedBox(height: 110), // Jarak untuk AppBar
              
              // SEARCH BAR MELAYANG
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))
                    ],
                  ),
                  child: TextField(
                    onChanged: _runFilter,
                    decoration: InputDecoration(
                      hintText: "Cari nama atau kode produk...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: _primaryColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // GRAFIK DASHBOARD
              if (_showChart && _allProduk.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DashboardStats(listProduk: _allProduk),
                ),

              // GRID LIST PRODUK
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _foundProduk.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _fetchProduk,
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 90), // Padding bawah agar tidak tertutup tombol tambah
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 220, 
                                childAspectRatio: 0.72, // Sedikit lebih tinggi untuk gambar
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                              itemCount: _foundProduk.length,
                              itemBuilder: (context, index) => _buildModernCard(_foundProduk[index]),
                            ),
                          ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProdukForm()));
          _fetchProduk();
        },
        label: const Text("Tambah Produk", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_shopping_cart),
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }

  // --- WIDGET MENU SAMPING (DRAWER) ---
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Admin Gudang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text("admin@tokomaju.com"),
            currentAccountPicture: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Icon(Icons.person, size: 50, color: _primaryColor),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_primaryColor, Colors.blue.shade600]),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded, color: _primaryColor),
            title: const Text('Dashboard Analitik'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _showChart = true);
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf_rounded, color: Colors.red[700]),
            title: const Text('Download Laporan PDF'),
            onTap: () {
              Navigator.pop(context);
              _createPdf();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.grey),
            title: const Text('Keluar Aplikasi'),
            onTap: () {}, 
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTU PRODUK MODERN ---
  Widget _buildModernCard(Produk produk) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)))
                .then((value) => _fetchProduk());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. AREA GAMBAR PRODUK
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: Colors.blue.shade50,
                  ),
                  // Cek apakah produk memiliki nama file gambar dari server
                  child: (produk.gambar != null && produk.gambar!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            BaseUrl.imageUrl + produk.gambar!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey.shade400),
                                const SizedBox(height: 5),
                                Text("No Image", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          // Jika tidak ada gambar, tampilkan inisial nama huruf pertama
                          child: Text(
                            produk.nama != null && produk.nama!.isNotEmpty ? produk.nama![0].toUpperCase() : '?',
                            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: _primaryColor.withOpacity(0.4)),
                          ),
                        ),
                ),
              ),
              
              // 2. INFO PRODUK BAWAH
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produk.nama ?? 'Tanpa Nama',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              produk.kode ?? '-',
                              style: TextStyle(fontSize: 10, color: Colors.indigo.shade700, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFormatter.format(produk.harga),
                            style: TextStyle(color: _accentColor, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                          Icon(Icons.arrow_circle_right_rounded, size: 18, color: Colors.grey[400])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET JIKA DATA KOSONG ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "Produk tidak ditemukan",
            style: TextStyle(color: Colors.grey[500], fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Coba ubah kata kunci pencarian Anda.",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}