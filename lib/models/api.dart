import 'package:flutter/foundation.dart';

class BaseUrl {
  static String baseUrl = kIsWeb ? "http://localhost/produk" : "http://10.0.2.2/produk"; 

  static String list = "$baseUrl/list.php";
  static String detail = "$baseUrl/detail.php";
  static String create = "$baseUrl/create.php";
  static String update = "$baseUrl/update.php";
  static String delete = "$baseUrl/delete.php";
  
  // URL Akses Folder Gambar
  static String imageUrl = "$baseUrl/uploads/";
}