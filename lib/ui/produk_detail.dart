import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:produk_app/models/api.dart';
import 'package:produk_app/models/produk.dart';
import 'package:produk_app/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;
  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  // Fungsi refresh untuk mengambil data terbaru setelah edit
  // (Optional tapi bagus jika ingin data realtime tanpa kembali ke list)
  Future<void> refreshData() async {
    // Implementasi jika diperlukan, tapi kembali ke list (pop) biasanya cukup.
  }

  void deleteProduk(int id) async {
    // ... (Kode delete sama seperti sebelumnya) ...
    // Demi ringkas saya tidak tulis ulang bagian delete, fokus ke Edit
    // Gunakan kode delete dari jawaban sebelumnya
      try {
      final response = await http.post(
        Uri.parse(BaseUrl.delete),
        body: jsonEncode({"id": id}),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context); // Balik ke List
      } else {
        throw Exception('Gagal menghapus');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void confirmDelete() {
     // ... (Kode dialog sama seperti sebelumnya) ...
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Yakin ingin menghapus?"),
        actions: [
          TextButton(child: const Text("Batal"), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
             onPressed: () { Navigator.pop(context); deleteProduk(widget.produk.id!); }, 
             child: const Text("Hapus")
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: SingleChildScrollView(
        child: Column(
          children: [
             // Header visual
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.indigo,
              child: const Center(
                child: Icon(Icons.shopping_bag, size: 80, color: Colors.white54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama: ${widget.produk.nama}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Kode: ${widget.produk.kode}", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("Harga: ${currencyFormatter.format(widget.produk.harga)}", style: const TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit"),
                              onPressed: () async {
                                // NAVIGASI KE FORM EDIT
                                // Kita kirim object `widget.produk` ke ProdukForm
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProdukForm(produk: widget.produk),
                                  ),
                                );
                                // Setelah selesai edit dan kembali, kita close halaman detail
                                // agar user kembali ke list dan data ter-refresh
                                if (!mounted) return;
                                Navigator.pop(context); 
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text("Hapus"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                              onPressed: confirmDelete,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}