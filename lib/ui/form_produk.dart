import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:produk_app/models/api.dart';
import 'package:produk_app/models/produk.dart';
import 'package:produk_app/ui/scanner_page.dart'; // Import halaman scanner

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _kodeController;
  late TextEditingController _namaController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _kodeController = TextEditingController(text: widget.produk?.kode ?? '');
    _namaController = TextEditingController(text: widget.produk?.nama ?? '');
    _hargaController = TextEditingController(text: widget.produk?.harga?.toString() ?? '');
  }

  // Fungsi untuk membuka scanner
  void _scanBarcode() async {
    // Navigasi ke ScannerPage dan tunggu hasilnya
    final String? hasilScan = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    // Jika ada hasil, masukkan ke text field kode
    if (hasilScan != null) {
      setState(() {
        _kodeController.text = hasilScan;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Barcode terdeteksi: $hasilScan")),
      );
    }
  }

  // ... (Bagian Fungsi Simpan SAMA seperti kode sebelumnya, tidak perlu diubah) ...
  Future<void> simpan() async {
     // ... Copy paste logika simpan dari jawaban sebelumnya ...
     // Agar tidak terlalu panjang, saya persingkat di sini. 
     // Pastikan Anda menyalin fungsi simpan() yang sudah benar dari jawaban saya sebelumnya.
     if (!_formKey.currentState!.validate()) return;
     setState(() => _isLoading = true);
     try {
       bool isEdit = widget.produk != null;
       String url = isEdit ? BaseUrl.update : BaseUrl.create;
       Map<String, dynamic> bodyData = {
        'kode': _kodeController.text,
        'nama': _namaController.text,
        'harga': int.parse(_hargaController.text),
      };
      if (isEdit) bodyData['id'] = widget.produk!.id;

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );
      // Logic success/fail...
      if(response.statusCode == 200) {
          if(!mounted) return;
          Navigator.pop(context, true);
      }
     } catch (e) {
       // handle error
     } finally {
       setState(() => _isLoading = false);
     }
  }

  @override
  Widget build(BuildContext context) {
    String judul = widget.produk == null ? "Tambah Produk" : "Edit Produk";

    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- MODIFIKASI PADA TEXT FIELD KODE ---
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _kodeController,
                          decoration: InputDecoration(
                            labelText: "Kode Produk",
                            prefixIcon: const Icon(Icons.qr_code),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) => value!.isEmpty ? "Kode wajib diisi" : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Scan
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                          onPressed: _scanBarcode,
                          tooltip: "Scan Barcode",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Field Nama (Biasa)
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Produk",
                      prefixIcon: const Icon(Icons.inventory),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  const SizedBox(height: 20),

                  // Field Harga (Biasa)
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Harga",
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value!.isEmpty ? "Harga wajib diisi" : null,
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : simpan,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}