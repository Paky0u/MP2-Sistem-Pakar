<?php
require_once 'koneksi.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id > 0) {
    $sql = "DELETE FROM tb_riwayat WHERE id_riwayat = $id";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Riwayat dihapus"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal hapus: " . $conn->error]);
    }
} else {
    // Jika id == 0, hapus semua
    $sql = "TRUNCATE TABLE tb_riwayat";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Semua riwayat dibersihkan"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal bersihkan: " . $conn->error]);
    }
}

$conn->close();
?>
