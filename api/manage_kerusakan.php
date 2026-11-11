<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);
$action = isset($data['action']) ? $data['action'] : (isset($_GET['action']) ? $_GET['action'] : '');

if ($action === 'tambah') {
    if (!isset($data['kode_kerusakan']) || !isset($data['nama_kerusakan'])) {
        echo json_encode(["status" => "error", "message" => "Kode dan nama kerusakan wajib diisi."]);
        exit();
    }
    $kode = strtoupper(trim($data['kode_kerusakan']));
    $nama = trim($data['nama_kerusakan']);
    $deskripsi = isset($data['deskripsi']) ? trim($data['deskripsi']) : '-';
    $solusi = isset($data['solusi']) ? trim($data['solusi']) : '-';
    $hardware = isset($data['hardware']) ? trim($data['hardware']) : '-';
    $imagePath = isset($data['image_path']) && !empty($data['image_path']) ? trim($data['image_path']) : 'assets/images/motherboard.jpg';

    if (empty($kode) || empty($nama)) {
        echo json_encode(["status" => "error", "message" => "Kode dan nama tidak boleh kosong."]);
        exit();
    }

    // Cek duplikat
    $cek = $conn->prepare("SELECT kode_kerusakan FROM tb_kerusakan WHERE kode_kerusakan = ?");
    $cek->bind_param("s", $kode);
    $cek->execute();
    if ($cek->get_result()->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Kode kerusakan '$kode' sudah terdaftar."]);
        $cek->close();
        exit();
    }
    $cek->close();

    $stmt = $conn->prepare("INSERT INTO tb_kerusakan (kode_kerusakan, nama_kerusakan, deskripsi, solusi, hardware, image_path) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $kode, $nama, $deskripsi, $solusi, $hardware, $imagePath);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Kerusakan baru berhasil ditambahkan!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menambah data: " . $conn->error]);
    }
    $stmt->close();

} elseif ($action === 'edit') {
    if (!isset($data['kode_kerusakan']) || !isset($data['nama_kerusakan'])) {
        echo json_encode(["status" => "error", "message" => "Kode dan nama kerusakan wajib diisi."]);
        exit();
    }
    $kode = trim($data['kode_kerusakan']);
    $nama = trim($data['nama_kerusakan']);
    $deskripsi = isset($data['deskripsi']) ? trim($data['deskripsi']) : '-';
    $solusi = isset($data['solusi']) ? trim($data['solusi']) : '-';
    $hardware = isset($data['hardware']) ? trim($data['hardware']) : '-';
    $imagePath = isset($data['image_path']) && !empty($data['image_path']) ? trim($data['image_path']) : 'assets/images/motherboard.jpg';

    $stmt = $conn->prepare("UPDATE tb_kerusakan SET nama_kerusakan = ?, deskripsi = ?, solusi = ?, hardware = ?, image_path = ? WHERE kode_kerusakan = ?");
    $stmt->bind_param("ssssss", $nama, $deskripsi, $solusi, $hardware, $imagePath, $kode);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Data kerusakan berhasil diperbarui!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal memperbarui: " . $conn->error]);
    }
    $stmt->close();

} elseif ($action === 'hapus') {
    $kode = isset($data['kode_kerusakan']) ? trim($data['kode_kerusakan']) : (isset($_GET['kode_kerusakan']) ? trim($_GET['kode_kerusakan']) : '');
    if (empty($kode)) {
        echo json_encode(["status" => "error", "message" => "Kode kerusakan tidak diberikan."]);
        exit();
    }

    $stmt = $conn->prepare("DELETE FROM tb_kerusakan WHERE kode_kerusakan = ?");
    $stmt->bind_param("s", $kode);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Kerusakan berhasil dihapus!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menghapus: " . $conn->error]);
    }
    $stmt->close();

} else {
    echo json_encode(["status" => "error", "message" => "Aksi tidak dikenal."]);
}

$conn->close();
?>
