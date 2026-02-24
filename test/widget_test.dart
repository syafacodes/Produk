import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Pastikan import ini sesuai dengan nama project di pubspec.yaml Anda
import 'package:produk_app/main.dart';

void main() {
  testWidgets('Tes tampilan awal aplikasi produk', (WidgetTester tester) async {
    // 1. Build aplikasi (Load MyApp)
    await tester.pumpWidget(const MyApp());

    // 2. Verifikasi bahwa judul 'List Produk' ada di AppBar
    expect(find.text('List Produk'), findsOneWidget);

    // 3. Verifikasi bahwa tombol Tambah (+) ada di AppBar
    expect(find.byIcon(Icons.add), findsOneWidget);

    // 4. Verifikasi bahwa CircularProgressIndicator muncul 
    // (Karena saat awal aplikasi dibuka, statusnya pasti sedang loading data)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}