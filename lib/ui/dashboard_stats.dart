import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:produk_app/models/produk.dart';

class DashboardStats extends StatelessWidget {
  final List<Produk> listProduk;

  const DashboardStats({super.key, required this.listProduk});

  @override
  Widget build(BuildContext context) {
    // Logika Sederhana untuk Data Grafik
    int murah = listProduk.where((p) => (p.harga ?? 0) < 50000).length;
    int sedang = listProduk.where((p) => (p.harga ?? 0) >= 50000 && (p.harga ?? 0) < 100000).length;
    int mahal = listProduk.where((p) => (p.harga ?? 0) >= 100000).length;

    // Menghitung Total Aset
    int totalAset = listProduk.fold(0, (sum, item) => sum + (item.harga ?? 0));

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Analisis Stok Barang", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: murah.toDouble(),
                      title: '$murah',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: sedang.toDouble(),
                      title: '$sedang',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: mahal.toDouble(),
                      title: '$mahal',
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _legend(Colors.green, "< 50rb (Murah)"),
                _legend(Colors.orange, "50rb - 100rb"),
                _legend(Colors.red, "> 100rb (Mahal)"),
              ],
            ),
            const Divider(height: 30),
            Text("Total Nilai Aset: Rp $totalAset", 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}