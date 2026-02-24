import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:produk_app/models/api.dart';
import 'package:produk_app/models/produk.dart';
import 'package:produk_app/ui/scanner_page.dart'; // Pastikan file scanner_page.dart sudah ada

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
    // Inisialisasi controller
    _kodeController = TextEditingController(text: widget.produk?.kode ?? '');
    _namaController = TextEditingController(text: widget.produk?.nama ?? '');
    _hargaController = TextEditingController(text: widget.produk?.harga?.toString() ?? '');
  }

  // Fungsi Scan Barcode
  void _scanBarcode() async {
    final String? hasilScan = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (hasilScan != null) {
      setState(() {
        _kodeController.text = hasilScan;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Barcode: $hasilScan")),
      );
    }
  }

  // Fungsi Simpan (Create / Update)
  Future<void> simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      bool isEdit = widget.produk != null;
      String url = isEdit ? BaseUrl.update : BaseUrl.create;

      // Siapkan data body
      Map<String, dynamic> bodyData = {
        'kode': _kodeController.text,
        'nama': _namaController.text,
        'harga': int.parse(_hargaController.text),
      };

      // PENTING: Jika Edit, wajib sertakan ID
      if (isEdit) {
        bodyData['id'] = widget.produk!.id;
      }

      print("URL: $url");
      print("JSON: ${jsonEncode(bodyData)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] != null) throw Exception(data['error']);
        
        if (!mounted) return;
        Navigator.pop(context, true); // Kembali ke halaman sebelumnya
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan"), backgroundColor: Colors.green),
        );
      } else {
        throw Exception('Gagal menyimpan. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- INPUT KODE PRODUK DENGAN TOMBOL SCANNER ---
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
                          validator: (value) => value!.isEmpty ? "Kode harus diisi" : null,
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

                  // --- INPUT NAMA PRODUK ---
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Produk",
                      prefixIcon: const Icon(Icons.inventory),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value!.isEmpty ? "Nama harus diisi" : null,
                  ),
                  const SizedBox(height: 20),

                  // --- INPUT HARGA ---
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Harga (Rupiah)",
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value!.isEmpty ? "Harga harus diisi" : null,
                  ),
                  const SizedBox(height: 30),

                  // --- TOMBOL SIMPAN ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("SIMPAN DATA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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