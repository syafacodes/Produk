import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:produk_app/models/api.dart';
import 'package:produk_app/models/produk.dart';
import 'package:produk_app/ui/scanner_page.dart';

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

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes; // Menyimpan data gambar sementara untuk ditampilkan
  String? _base64Image;   // String yang akan dikirim ke PHP

  @override
  void initState() {
    super.initState();
    _kodeController = TextEditingController(text: widget.produk?.kode ?? '');
    _namaController = TextEditingController(text: widget.produk?.nama ?? '');
    _hargaController = TextEditingController(text: widget.produk?.harga?.toString() ?? '');
  }

  // Fungsi Pilih Gambar dari Galeri
  Future<void> _pickImage() async {
    // Kualitas gambar dikurangi menjadi 50% agar string Base64 tidak terlalu besar
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  // Fungsi Buka Scanner Barcode
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
        SnackBar(content: Text("Barcode terdeteksi: $hasilScan")),
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

      Map<String, dynamic> bodyData = {
        'kode': _kodeController.text,
        'nama': _namaController.text,
        'harga': int.parse(_hargaController.text),
      };

      if (isEdit) bodyData['id'] = widget.produk!.id;
      if (_base64Image != null) bodyData['gambar'] = _base64Image; // Tambahkan gambar jika ada

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] != null) throw Exception(data['error']);
        
        if (!mounted) return;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan"), backgroundColor: Colors.green),
        );
      } else {
        throw Exception('Gagal menyimpan. HTTP Status: ${response.statusCode}');
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
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- AREA UPLOAD GAMBAR ---
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFF1A237E), width: 2, style: BorderStyle.solid),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                  ),
                  child: _imageBytes != null
                      // Jika user baru memilih gambar, tampilkan gambar sementaranya
                      ? ClipRRect(borderRadius: BorderRadius.circular(13), child: Image.memory(_imageBytes!, fit: BoxFit.cover))
                      // Jika sedang edit dan ada gambar lama, tampilkan dari server
                      : (widget.produk?.gambar != null && widget.produk!.gambar!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.network(
                                BaseUrl.imageUrl + widget.produk!.gambar!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                              ),
                            )
                          // Jika tambah baru dan belum milih gambar
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_rounded, size: 60, color: Color(0xFF1A237E)),
                                const SizedBox(height: 10),
                                Text(
                                  "Ketuk untuk Upload Foto Produk",
                                  style: TextStyle(color: Colors.indigo.shade900, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 30),

              // --- FIELD KODE PRODUK + SCANNER ---
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _kodeController,
                      decoration: InputDecoration(
                        labelText: "Kode Produk",
                        prefixIcon: const Icon(Icons.qr_code, color: Color(0xFF1A237E)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value!.isEmpty ? "Kode wajib diisi" : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
                      onPressed: _scanBarcode,
                      tooltip: "Scan Barcode",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- FIELD NAMA PRODUK ---
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: "Nama Produk",
                  prefixIcon: const Icon(Icons.inventory_2_rounded, color: Color(0xFF1A237E)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // --- FIELD HARGA ---
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga (Rupiah)",
                  prefixIcon: const Icon(Icons.attach_money_rounded, color: Color(0xFF1A237E)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? "Harga wajib diisi" : null,
              ),
              const SizedBox(height: 40),

              // --- TOMBOL SIMPAN ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA000), // Warna Amber
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text("SIMPAN DATA PRODUK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}