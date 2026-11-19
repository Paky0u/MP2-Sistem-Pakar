<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['tanggal'], $data['gejala_dipilih'], $data['kode_kerusakan'], $data['nama_kerusakan'], $data['persentase'])) {
    $idUser = isset($data['id_user']) && !empty($data['id_user']) ? (int)$data['id_user'] : null;
    $tanggal = trim($data['tanggal']);
    $gejala = trim($data['gejala_dipilih']);
    $kode = trim($data['kode_kerusakan']);
    $nama = trim($data['nama_kerusakan']);
    $persen = (int)$data['persentase'];
    $hasilJson = isset($data['hasil_json']) ? $data['hasil_json'] : null;

    if ($idUser !== null) {
        $stmt = $conn->prepare("INSERT INTO tb_riwayat (id_user, tanggal, gejala_dipilih, kode_kerusakan, nama_kerusakan, persentase, hasil_json) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("issssis", $idUser, $tanggal, $gejala, $kode, $nama, $persen, $hasilJson);
    } else {
        $stmt = $conn->prepare("INSERT INTO tb_riwayat (tanggal, gejala_dipilih, kode_kerusakan, nama_kerusakan, persentase, hasil_json) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssis", $tanggal, $gejala, $kode, $nama, $persen, $hasilJson);
    }

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Riwayat disimpan", "id_riwayat" => $conn->insert_id]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal simpan: " . $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}

$conn->close();
?>
