<?php
header('Content-Type: application/json');
include 'konekdb.php';

// 1. Ambil data JSON
$data = json_decode(file_get_contents('php://input'), true);

// 2. Cek ID
if (!isset($data['id'])) {
    echo json_encode(['pesan' => 'Butuh ID untuk menghapus']);
    exit;
}

try {
    // 3. Siapkan perintah DELETE
    $stmt = $konekdb->prepare("DELETE FROM produk WHERE id = :id");
    
    // 4. Masukkan ID ke perintah
    $stmt->bindParam(':id', $data['id']);
    
    // 5. Jalankan
    $stmt->execute();
    
    echo json_encode(['pesan' => 'Sukses hapus data']);
} catch (PDOException $e) {
    echo json_encode(['pesan' => 'Gagal hapus: ' . $e->getMessage()]);
}
?>