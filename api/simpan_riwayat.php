<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['tanggal'], $data['gejala_dipilih'], $data['kode_kerusakan'], $data['nama_kerusakan'], $data['persentase'])) {
    $tanggal = $conn->real_escape_string($data['tanggal']);
    $gejala = $conn->real_escape_string($data['gejala_dipilih']);
    $kode = $conn->real_escape_string($data['kode_kerusakan']);
    $nama = $conn->real_escape_string($data['nama_kerusakan']);
    $persen = (int)$data['persentase'];

    $sql = "INSERT INTO tb_riwayat (tanggal, gejala_dipilih, kode_kerusakan, nama_kerusakan, persentase) 
            VALUES ('$tanggal', '$gejala', '$kode', '$nama', $persen)";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Riwayat disimpan"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal simpan: " . $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}

$conn->close();
?>
