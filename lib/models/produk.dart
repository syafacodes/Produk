class Produk {
  int? id;
  String? kode;
  String? nama;
  int? harga;
  String? gambar; // TAMBAHAN BARU: Properti untuk menyimpan nama file gambar

  Produk({this.id, this.kode, this.nama, this.harga, this.gambar});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      // Konversi paksa ke int agar aman dari error tipe data
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      kode: json['kode'],
      nama: json['nama'],
      // Konversi harga juga, kadang PHP kirim angka sebagai string
      harga: json['harga'] == null ? 0 : int.parse(json['harga'].toString()),
      // TAMBAHAN BARU: Menerima data nama file gambar dari JSON API PHP
      gambar: json['gambar']?.toString(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'nama': nama,
      'harga': harga,
      'gambar': gambar, // TAMBAHAN BARU: Menyertakan data gambar (Base64/Nama File) saat dikirim ke server
    };
  }
}