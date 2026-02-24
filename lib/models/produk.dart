class Produk {
  int? id;
  String? kode;
  String? nama;
  int? harga;

  Produk({this.id, this.kode, this.nama, this.harga});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      // Konversi paksa ke int agar aman dari error tipe data
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      kode: json['kode'],
      nama: json['nama'],
      // Konversi harga juga, kadang PHP kirim angka sebagai string
      harga: json['harga'] == null ? 0 : int.parse(json['harga'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'nama': nama,
      'harga': harga,
    };
  }
}