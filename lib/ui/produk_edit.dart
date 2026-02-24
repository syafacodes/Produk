import 'package:flutter/material.dart';
import 'package:produk_app/models/produk.dart';
import 'package:produk_app/ui/produk_form.dart';

class ProdukEdit extends StatelessWidget {
  final Produk produk;
  const ProdukEdit({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    // Memanggil ProdukForm dengan parameter produk (Mode Edit)
    return ProdukForm(produk: produk);
  }
}