<?php
require_once 'koneksi.php';

$sql = "SELECT * FROM tb_gejala ORDER BY kode_gejala ASC";
$result = $conn->query($sql);

$gejala = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $gejala[] = array(
            'kode' => $row['kode_gejala'],
            'nama' => $row['nama_gejala']
        );
    }
}

echo json_encode($gejala);
$conn->close();
?>
