class Produk {
  int? id;
  String? kode;
  String? nama;
  int? harga;

  Produk({this.id, this.kode, this.nama, this.harga});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      // Parsing ID harus aman dari String maupun Integer
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      kode: json['kode'].toString(),
      nama: json['nama'].toString(),
      harga: json['harga'] is int ? json['harga'] : int.tryParse(json['harga'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Pastikan ID ini terbawa saat update
      'kode': kode,
      'nama': nama,
      'harga': harga,
    };
  }
}