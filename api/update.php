<?php
// === BAGIAN HEADER CORS (WAJIB ADA DI PALING ATAS) ===
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Izinkan metode POST dan OPTIONS

// Handle preflight request (Penting untuk Chrome)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

header('Content-Type: application/json');
include 'konekdb.php';

// === LOGIKA UPDATE ===

// 1. Ambil data JSON yang dikirim
$data = json_decode(file_get_contents('php://input'), true);

// 2. Cek apakah ID ada
if (!isset($data['id'])) {
    echo json_encode(['error' => 'ID tidak ditemukan dalam data yang dikirim']);
    exit;
}

// 3. Cek kelengkapan data lain
if (!isset($data['kode']) || !isset($data['nama']) || !isset($data['harga'])) {
    echo json_encode(['error' => 'Data tidak lengkap (kode, nama, atau harga hilang)']);
    exit;
}

try {
    // 4. Siapkan perintah UPDATE
    $stmt = $konekdb->prepare("UPDATE produk SET kode = :kode, nama = :nama, harga = :harga WHERE id = :id");

    // 5. Masukkan data ke perintah SQL
    // Pastikan tipe data id dan harga adalah integer
    $id = (int) $data['id'];
    $kode = $data['kode'];
    $nama = $data['nama'];
    $harga = (int) $data['harga'];

    $stmt->bindParam(':id', $id);
    $stmt->bindParam(':kode', $kode);
    $stmt->bindParam(':nama', $nama);
    $stmt->bindParam(':harga', $harga);  

    // 6. Jalankan
    $stmt->execute();
    
    // Cek apakah ada baris yang berubah
    if ($stmt->rowCount() > 0) {
        echo json_encode(['pesan' => 'Sukses update data']);
    } else {
        // Jika tidak ada yang berubah (mungkin data sama persis) tetap kita anggap sukses atau info
        echo json_encode(['pesan' => 'Data berhasil disimpan (Tidak ada perubahan data)']);
    }

} catch (PDOException $e) {
    echo json_encode(['error' => 'Gagal update: ' . $e->getMessage()]);
}
?>