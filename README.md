# 📦 Aplikasi Manajemen Produk

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white" alt="PHP" />
  <img src="https://img.shields.io/badge/MySQL-000000?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
</p>

<p align="center">
  <b>Aplikasi mobile pintar untuk mengelola data inventaris produk.</b><br>
  Dilengkapi dengan fitur Full CRUD, Dashboard Statistik, dan integrasi Scanner Barcode/QR Code.
</p>

---

## 📸 Galeri Aplikasi

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Dashboard</b></td>
      <td align="center"><b>Tambah Produk</b></td>
      <td align="center"><b>Edit Produk</b></td>
      <td align="center"><b>Statistik</b></td>
      <td align="center"><b>laporan</b></td>
      <td align="center"><b>Detail Produk</b></td>
    </tr>
    <tr>
      <td align="center">
       <img width="1365" height="767" alt="Screenshot_83" src="https://github.com/user-attachments/assets/93c7e49f-7061-4d24-bf76-53f93608be67" />
      </td>
      <td align="center">
        <img width="1365" height="767" alt="Screenshot_82" src="https://github.com/user-attachments/assets/975eab5c-f0cd-49cb-986d-d46f98a79aad" />
      </td>
      <td align="center">
        <img width="1365" height="722" alt="Screenshot_82" src="https://github.com/user-attachments/assets/3e97ad9b-753c-41e3-8e44-723a3a380f3f" />
      </td>
      <td align="center">
       <img width="1365" height="724" alt="Screenshot_85" src="https://github.com/user-attachments/assets/eddcf6ae-f936-4247-9558-3f1915cb6fbf" />
      </td>
      <td align="center">
     <img width="1365" height="721" alt="Screenshot_82" src="https://github.com/user-attachments/assets/da40e3d2-1806-4663-882a-1b6bef22b048" />
      </td>
    </tr>
  </table>
</div>

## ✨ Fitur Utama

Aplikasi ini tidak hanya melakukan operasi dasar, tapi juga dilengkapi fitur pendukung inventaris:

* 📊 **Dashboard Statistik:** Menampilkan ringkasan data produk secara *real-time*.
* 📷 **Barcode/QR Scanner:** Memindai kode produk langsung dari kamera HP untuk pencarian atau input data yang lebih cepat.
* 📖 **Manajemen Produk (CRUD):**
    * **Create:** Tambah data produk baru beserta detail harganya.
    * **Read:** Tampilkan daftar produk dari database dengan rapi.
    * **Update:** Edit dan perbarui informasi produk yang sudah ada.
    * **Delete:** Hapus data produk yang sudah tidak relevan.

## 🛠️ Teknologi Stack

| Kategori | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Frontend** | ![Flutter](https://img.shields.io/badge/-Flutter-grey?logo=flutter) | Framework UI untuk membangun aplikasi mobile. |
| **Backend API** | ![PHP](https://img.shields.io/badge/-PHP-grey?logo=php) | Script API native (`create.php`, `list.php`, dll) untuk logika *backend*. |
| **Database** | ![MySQL](https://img.shields.io/badge/-MySQL-grey?logo=mysql) | Penyimpanan data inventaris produk. |

---

## 🚀 Cara Menjalankan Project (Lokal)

### 1. Setup Backend (PHP & MySQL)
1. Gunakan XAMPP/Laragon dan jalankan Apache & MySQL.
2. Buat database baru di phpMyAdmin (misal: `db_produk`).
3. Import struktur tabel produk ke database tersebut.
4. Letakkan folder `api` yang berisi file PHP ke dalam folder `htdocs` (jika pakai XAMPP).
5. Sesuaikan konfigurasi *username* dan *password* database di file `api/konekdb.php`.

### 2. Setup Frontend (Flutter)
1. Buka terminal dan clone repository ini:
   ```bash
   git clone [https://github.com/syafacodes/Produk.git](https://github.com/syafacodes/Produk.git)
