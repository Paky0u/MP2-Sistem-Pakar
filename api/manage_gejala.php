<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);
$action = isset($data['action']) ? $data['action'] : (isset($_GET['action']) ? $_GET['action'] : '');

if ($action === 'tambah') {
    if (!isset($data['kode_gejala']) || !isset($data['nama_gejala'])) {
        echo json_encode(["status" => "error", "message" => "Kode dan nama gejala wajib diisi."]);
        exit();
    }
    $kode = strtoupper(trim($data['kode_gejala']));
    $nama = trim($data['nama_gejala']);

    if (empty($kode) || empty($nama)) {
        echo json_encode(["status" => "error", "message" => "Kode dan nama tidak boleh kosong."]);
        exit();
    }

    // Cek duplikat
    $cek = $conn->prepare("SELECT kode_gejala FROM tb_gejala WHERE kode_gejala = ?");
    $cek->bind_param("s", $kode);
    $cek->execute();
    if ($cek->get_result()->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Kode gejala '$kode' sudah ada."]);
        $cek->close();
        exit();
    }
    $cek->close();

    $stmt = $conn->prepare("INSERT INTO tb_gejala (kode_gejala, nama_gejala) VALUES (?, ?)");
    $stmt->bind_param("ss", $kode, $nama);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Gejala berhasil ditambahkan!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menambah gejala: " . $conn->error]);
    }
    $stmt->close();

} elseif ($action === 'edit') {
    if (!isset($data['kode_gejala']) || !isset($data['nama_gejala'])) {
        echo json_encode(["status" => "error", "message" => "Kode dan nama gejala wajib diisi."]);
        exit();
    }
    $kode = trim($data['kode_gejala']);
    $nama = trim($data['nama_gejala']);

    $stmt = $conn->prepare("UPDATE tb_gejala SET nama_gejala = ? WHERE kode_gejala = ?");
    $stmt->bind_param("ss", $nama, $kode);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Gejala berhasil diperbarui!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal memperbarui: " . $conn->error]);
    }
    $stmt->close();

} elseif ($action === 'hapus') {
    $kode = isset($data['kode_gejala']) ? trim($data['kode_gejala']) : (isset($_GET['kode_gejala']) ? trim($_GET['kode_gejala']) : '');
    if (empty($kode)) {
        echo json_encode(["status" => "error", "message" => "Kode gejala tidak diberikan."]);
        exit();
    }

    $stmt = $conn->prepare("DELETE FROM tb_gejala WHERE kode_gejala = ?");
    $stmt->bind_param("s", $kode);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Gejala berhasil dihapus!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menghapus: " . $conn->error]);
    }
    $stmt->close();

} else {
    echo json_encode(["status" => "error", "message" => "Aksi tidak dikenal."]);
}

$conn->close();
?>
