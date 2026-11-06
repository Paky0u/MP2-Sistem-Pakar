<?php
require_once 'koneksi.php';

$sql = "SELECT * FROM tb_riwayat ORDER BY id_riwayat DESC";
$result = $conn->query($sql);

$riwayat = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $riwayat[] = array(
            'id_riwayat' => (int)$row['id_riwayat'],
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
