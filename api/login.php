<?php
require_once 'koneksi.php';

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['email']) || !isset($data['password'])) {
    echo json_encode([
        "status" => "error",
        "message" => "Email dan password wajib diisi."
    ]);
    exit();
}

$email = trim(strtolower($data['email']));
$password = $data['password'];

$stmt = $conn->prepare("SELECT id_user, nama, email, password, role FROM tb_user WHERE email = ? LIMIT 1");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result && $row = $result->fetch_assoc()) {
    $dbPass = $row['password'];
    $isValid = false;

    if (password_verify($password, $dbPass)) {
        $isValid = true;
    } elseif ($dbPass === md5($password)) {
        // Fallback untuk seed akun legacy md5
        $isValid = true;
    } elseif ($dbPass === $password) {
        // Fallback jika plain text
        $isValid = true;
    }

    if ($isValid) {
        echo json_encode([
            "status" => "success",
            "message" => "Login berhasil.",
            "user" => [
                "id_user" => (int)$row['id_user'],
                "nama" => $row['nama'],
                "email" => $row['email'],
                "role" => $row['role']
            ]
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Password yang Anda masukkan salah."
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Akun dengan email tersebut tidak ditemukan."
    ]);
}

$stmt->close();
$conn->close();
?>

