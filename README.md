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
      <td align="center"><b>Statistik</b></td>
      <td align="center"><b>laporan</b></td>
      <td align="center"><b>Detail Produk</b></td>
    </tr>
    <tr>
      <td align="center">
       <img width="1365" height="724" alt="Screenshot_82" src="https://github.com/user-attachments/assets/8ea5e256-c5c6-469c-9fc0-37c554fbb199" />
      </td>
      <td align="center">
        <img width="1365" height="722" alt="Screenshot_83" src="https://github.com/user-attachments/assets/e50f8586-d20a-45b9-8ef5-1ba92684d7a7" />
      </td>
      <td align="center">
        <img width="1365" height="720" alt="Screenshot_84" src="https://github.com/user-attachments/assets/1d9e2af6-89aa-4b95-bf2d-75bcb8ab5db6" />
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
