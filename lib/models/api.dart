import 'package:flutter/foundation.dart'; // Import ini penting untuk kIsWeb

class BaseUrl {
  // Logic otomatis:
  // Jika dijalankan di Web (kIsWeb true) -> pakai localhost
  // Jika dijalankan di HP/Emulator -> pakai 10.0.2.2
  // Ganti 'produk' sesuai nama folder PHP Anda di htdocs
  static String baseUrl = kIsWeb 
      ? "http://localhost/produk" 
      : "http://10.0.2.2/produk"; 

  static String list = "$baseUrl/list.php";
  static String detail = "$baseUrl/detail.php";
  static String create = "$baseUrl/create.php";
  static String update = "$baseUrl/update.php";
  static String delete = "$baseUrl/delete.php";
}