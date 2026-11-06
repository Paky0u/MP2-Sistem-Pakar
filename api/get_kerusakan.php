<?php
require_once 'koneksi.php';

$sql = "SELECT * FROM tb_kerusakan ORDER BY kode_kerusakan ASC";
$result = $conn->query($sql);

$kerusakan = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $kerusakan[] = array(
            'kode' => $row['kode_kerusakan'],
            'nama' => $row['nama_kerusakan'],
            'deskripsi' => $row['deskripsi'],
            'solusi' => $row['solusi'],
            'hardware' => $row['hardware'],
            'imagePath' => $row['image_path']
        );
    }
}

echo json_encode($kerusakan);
$conn->close();
?>
