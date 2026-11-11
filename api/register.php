<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['nama']) || !isset($data['email']) || !isset($data['password'])) {
    echo json_encode([
        "status" => "error",
        "message" => "Data pendaftaran tidak lengkap."
    ]);
    exit();
}

$nama = trim($data['nama']);
$email = trim(strtolower($data['email']));
$password = $data['password'];

if (empty($nama) || empty($email) || empty($password)) {
    echo json_encode([
        "status" => "error",
        "message" => "Semua kolom wajib diisi."
    ]);
    exit();
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode([
        "status" => "error",
        "message" => "Format email tidak valid."
    ]);
    exit();
}

// Cek apakah email sudah terdaftar
$checkStmt = $conn->prepare("SELECT id_user FROM tb_user WHERE email = ?");
$checkStmt->bind_param("s", $email);
$checkStmt->execute();
$checkResult = $checkStmt->get_result();

if ($checkResult && $checkResult->num_rows > 0) {
    echo json_encode([
        "status" => "error",
        "message" => "Email sudah terdaftar. Silakan login."
    ]);
    $checkStmt->close();
    $conn->close();
    exit();
}
$checkStmt->close();

// Hash password
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);
$role = 'user';

$stmt = $conn->prepare("INSERT INTO tb_user (nama, email, password, role) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $nama, $email, $hashedPassword, $role);

if ($stmt->execute()) {
    $newId = $conn->insert_id;
    echo json_encode([
        "status" => "success",
        "message" => "Pendaftaran berhasil! Silakan login.",
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
        "message" => "Gagal mendaftar: " . $conn->error
    ]);
}

$stmt->close();
$conn->close();
?>

