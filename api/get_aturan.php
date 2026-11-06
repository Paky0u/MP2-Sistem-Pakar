<?php
require_once 'koneksi.php';

$sql = "SELECT kode_kerusakan, GROUP_CONCAT(kode_gejala) as kondisi FROM tb_aturan GROUP BY kode_kerusakan";
$result = $conn->query($sql);

$aturan = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $aturan[] = array(
            'hasil' => $row['kode_kerusakan'],
            'kondisi' => explode(',', $row['kondisi'])
        );
    }
}

echo json_encode($aturan);
$conn->close();
?>
