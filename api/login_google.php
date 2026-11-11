<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['email']) || empty($data['email'])) {
    echo json_encode([
        "status" => "error",
        "message" => "Email Google tidak ditemukan."
    ]);
    exit();
}

$email = trim(strtolower($data['email']));
$nama = isset($data['nama']) && !empty($data['nama']) ? trim($data['nama']) : 'User Google';
$googleId = isset($data['google_id']) ? trim($data['google_id']) : null;

// Cek apakah user dengan email ini sudah ada
$stmt = $conn->prepare("SELECT id_user, nama, email, role, google_id FROM tb_user WHERE email = ? LIMIT 1");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result && $row = $result->fetch_assoc()) {
    // User sudah ada di database
    $idUser = (int)$row['id_user'];
    $role = $row['role'];
    $namaDB = $row['nama'];

    // Update google_id jika sebelumnya belum ada
    if ($googleId && empty($row['google_id'])) {
        $updateStmt = $conn->prepare("UPDATE tb_user SET google_id = ? WHERE id_user = ?");
        $updateStmt->bind_param("si", $googleId, $idUser);
        $updateStmt->execute();
        $updateStmt->close();
    }

    echo json_encode([
        "status" => "success",
        "message" => "Login Google berhasil.",
        "user" => [
            "id_user" => $idUser,
            "nama" => $namaDB,
            "email" => $email,
            "role" => $role
        ]
    ]);
} else {
    // User baru -> Otomatis daftarkan
    $role = 'user';
    $insertStmt = $conn->prepare("INSERT INTO tb_user (nama, email, google_id, role) VALUES (?, ?, ?, ?)");
    $insertStmt->bind_param("ssss", $nama, $email, $googleId, $role);

    if ($insertStmt->execute()) {
        $newId = $conn->insert_id;
        echo json_encode([
            "status" => "success",
            "message" => "Akun berhasil dibuat via Google Sign-In.",
            "user" => [
                "id_user" => $newId,
                "nama" => $nama,
                "email" => $email,
                "role" => $role
            ]
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Gagal mendaftarkan akun Google: " . $conn->error
        ]);
    }
    $insertStmt->close();
}

$stmt->close();
$conn->close();
?>

