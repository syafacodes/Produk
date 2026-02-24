import 'package:flutter/material.dart';
import 'package:produk_app/ui/produk_form.dart';

class ProdukAdd extends StatelessWidget {
  const ProdukAdd({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil ProdukForm tanpa parameter produk (Mode Tambah)
    return const ProdukForm();
  }
}