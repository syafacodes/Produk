<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header('Content-Type: application/json');

include 'konekdb.php';
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['kode']) || !isset($data['nama']) || !isset($data['harga'])) {
    echo json_encode(['error' => 'Kehilangan baris yang di butuhkan']);
    exit;
}

$kode = $data['kode'];
$nama = $data['nama'];
$harga = $data['harga'];
try {
    $stmt = $konekdb->prepare("INSERT INTO produk (kode, nama, harga) VALUES (:kode, :nama, :harga)");
    $stmt->bindParam(':kode', $kode);
    $stmt->bindParam(':nama', $nama);
    $stmt->bindParam(':harga', $harga);
    $stmt->execute();

    echo json_encode(['Sukses' => 'Produk Berhasil di tambahken', 'id' => $konekdb->lastInsertId()]);
} catch (PDOException $e) {
    echo json_encode(['Emror' => $e->getMessage()]);
}
?>