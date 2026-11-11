<?php
require_once 'koneksi.php';

$idUser = isset($_GET['id_user']) && !empty($_GET['id_user']) ? (int)$_GET['id_user'] : 0;
$all = isset($_GET['all']) && $_GET['all'] == '1';

if ($all || $idUser === 0) {
    // Tampilkan semua riwayat (bisa untuk admin) beserta nama user jika ada
    $sql = "SELECT r.*, u.nama as nama_user, u.email as email_user 
            FROM tb_riwayat r 
            LEFT JOIN tb_user u ON r.id_user = u.id_user 
            ORDER BY r.id_riwayat DESC";
    $result = $conn->query($sql);
} else {
    // Tampilkan hanya riwayat milik user tertentu
    $stmt = $conn->prepare("SELECT r.*, u.nama as nama_user, u.email as email_user 
                           FROM tb_riwayat r 
                           LEFT JOIN tb_user u ON r.id_user = u.id_user 
                           WHERE r.id_user = ? 
                           ORDER BY r.id_riwayat DESC");
    $stmt->bind_param("i", $idUser);
    $stmt->execute();
    $result = $stmt->get_result();
}

$riwayat = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $riwayat[] = array(
            'id_riwayat' => (int)$row['id_riwayat'],
            'id_user' => isset($row['id_user']) ? (int)$row['id_user'] : null,
            'nama_user' => isset($row['nama_user']) ? $row['nama_user'] : 'Tamu',
            'email_user' => isset($row['email_user']) ? $row['email_user'] : '-',
            'tanggal' => $row['tanggal'],
            'gejala_dipilih' => $row['gejala_dipilih'],
            'kode_kerusakan' => $row['kode_kerusakan'],
            'nama_kerusakan' => $row['nama_kerusakan'],
            'persentase' => (int)$row['persentase']
        );
    }
}

echo json_encode($riwayat);
$conn->close();
?>
