CREATE DATABASE IF NOT EXISTS `db_diagnos_pc`;
USE `db_diagnos_pc`;

-- 1. Table Gejala
CREATE TABLE IF NOT EXISTS `tb_gejala` (
  `kode_gejala` VARCHAR(10) PRIMARY KEY,
  `nama_gejala` TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Table Kerusakan
CREATE TABLE IF NOT EXISTS `tb_kerusakan` (
  `kode_kerusakan` VARCHAR(10) PRIMARY KEY,
  `nama_kerusakan` VARCHAR(255) NOT NULL,
  `deskripsi` TEXT NOT NULL,
  `solusi` TEXT NOT NULL,
  `hardware` VARCHAR(100) NOT NULL,
  `image_path` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Table Aturan
CREATE TABLE IF NOT EXISTS `tb_aturan` (
  `id_aturan` INT AUTO_INCREMENT PRIMARY KEY,
  `kode_kerusakan` VARCHAR(10) NOT NULL,
  `kode_gejala` VARCHAR(10) NOT NULL,
  FOREIGN KEY (`kode_kerusakan`) REFERENCES `tb_kerusakan`(`kode_kerusakan`) ON DELETE CASCADE,
  FOREIGN KEY (`kode_gejala`) REFERENCES `tb_gejala`(`kode_gejala`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Table Riwayat
CREATE TABLE IF NOT EXISTS `tb_riwayat` (
  `id_riwayat` INT AUTO_INCREMENT PRIMARY KEY,
  `tanggal` VARCHAR(50) NOT NULL,
  `gejala_dipilih` TEXT NOT NULL,
  `kode_kerusakan` VARCHAR(10) NOT NULL,
  `nama_kerusakan` VARCHAR(255) NOT NULL,
  `persentase` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- SEED DATA --

-- Seed Gejala
INSERT IGNORE INTO `tb_gejala` (`kode_gejala`, `nama_gejala`) VALUES
('B01', 'Layar blank saat komputer dinyalakan'),
('B02', 'Munculnya garis horizontal atau vertikal di layar'),
('B03', 'Tidak muncul indikasi awal BIOS'),
('B04', 'Munculnya informasi error di BIOS'),
('B05', 'Keluar bunyi 1 bip panjang dan pendek berulang-ulang'),
('B06', 'Terdengar bunyi aneh pada Hard Drive'),
('B07', 'Kerap terjadi crash/freeze saat aplikasi dijalankan'),
('B08', 'Penyimpanan sering memindai saat proses booting'),
('B09', 'Munculnya informasi error saat aplikasi dijalankan'),
('B10', 'Perangkat tidak terdeteksi di pengelola perangkat meskipun driver sudah diinstalasi'),
('B11', 'Sistem operasi melakukan restart otomatis secara mendadak'),
('B12', 'Terjadi BSOD (Blue Screen of Death)'),
('B13', 'Tidak muncul suara meskipun driver sudah diinstalasi'),
('B14', 'Muncul error saat menjalankan aplikasi audio'),
('B15', 'Tidak ada tanda-tanda semua perangkat keras berfungsi (semua kipas tidak berputar)'),
('B16', 'Komputer/laptop sering mati mendadak tanpa sebab'),
('B17', 'Aplikasi berjalan lambat atau merespons dengan lambat'),
('B18', 'Performa grafis sangat berat (saat game/olah gambar)'),
('B19', 'Perangkat keras tidak terdeteksi di BIOS'),
('B20', 'BIOS memberikan informasi deteksi yang salah'),
('B21', 'Hanya beberapa perangkat keras yang berfungsi'),
('B22', 'Keyboard tidak terdeteksi'),
('B23', 'Kursor mouse tidak merespons gerakan dari mouse'),
('B24', 'Muncul gambar tidak proporsional atau pixel hitam di layar'),
('B25', 'Terdengar bunyi bip panjang saat laptop/komputer dihidupkan'),
('B26', 'Komputer/laptop sulit dinyalakan'),
('B27', 'Baterai tidak mengisi daya saat di-charge'),
('B28', 'Tidak ada tanda indikasi masuk daya'),
('B29', 'Komputer/laptop mati total'),
('B30', 'Laptop dalam kondisi charging lalu tiba-tiba layar mati'),
('B31', 'Bunyi bip keluar berulang'),
('B32', 'Tampilan Windows belum muncul sudah restart lagi (Gagal booting)'),
('B33', 'Kipas power supply tidak berputar'),
('B34', 'Kipas power supply dan kipas prosesor berputar'),
('B35', 'Muncul informasi "BIOS ROM checksum error - System halted"'),
('B36', 'Ketika menekan tombol power komputer/laptop tidak menyala');

-- Seed Kerusakan
INSERT IGNORE INTO `tb_kerusakan` (`kode_kerusakan`, `nama_kerusakan`, `deskripsi`, `solusi`, `hardware`, `image_path`) VALUES
('K01', 'Monitor Rusak', 'Monitor adalah perangkat output utama yang menampilkan informasi secara visual.', 'Periksa kabel VGA/HDMI/DisplayPort. Coba ganti kabel atau monitor lain. Jika tetap blank, bawa ke teknisi untuk pemeriksaan panel LCD.', 'Monitor', 'assets/images/monitor.jpg'),
('K02', 'Memori (RAM) Rusak', 'RAM adalah memori jangka pendek komputer yang digunakan saat menjalankan program.', 'Lepas dan pasang kembali RAM. Coba satu stick RAM saja. Bersihkan slot RAM. Jika masih bermasalah, ganti RAM baru.', 'RAM', 'assets/images/ram.jpg'),
('K03', 'Hard Drive Rusak', 'Hard Drive adalah media penyimpanan data utama komputer.', 'Backup data segera. Jalankan disk check (chkdsk). Jika ada bunyi klik/aneh, segera ganti Hard Drive baru sebelum data hilang.', 'Hard Drive', 'assets/images/harddrive.jpg'),
('K04', 'VGA (Kartu Grafis) Rusak', 'VGA Card adalah kartu yang memproses dan menampilkan grafis ke monitor.', 'Bersihkan VGA Card dan slot PCIe. Pastikan daya tambahan VGA terhubung. Coba pasang di slot lain. Jika masih rusak, ganti VGA Card.', 'VGA Card', 'assets/images/vga.jpg'),
('K05', 'Sound Card Rusak', 'Sound Card adalah komponen yang memproses audio input dan output.', 'Update driver audio. Periksa pengaturan suara di Device Manager. Coba gunakan USB sound card eksternal. Jika onboard, bawa ke teknisi.', 'Sound Card', 'assets/images/soundcard.jpg'),
('K06', 'Power Supply Rusak', 'Power Supply mengubah arus AC menjadi DC untuk mensuplai daya ke komponen komputer.', 'Ganti Power Supply dengan wattage yang sesuai. Pastikan semua konektor daya terpasang dengan benar. Bawa ke teknisi jika ragu.', 'Power Supply', 'assets/images/powersupply.jpg'),
('K07', 'Prosesor (CPU) Rusak', 'Prosesor adalah otak komputer yang menjalankan semua instruksi.', 'Bersihkan thermal paste dan ganti dengan yang baru. Pastikan heatsink terpasang kencang. Periksa suhu CPU. Jika overheating, perbaiki pendinginan.', 'Prosesor', 'assets/images/processor.jpg'),
('K08', 'Kabel Power Rusak', 'Kabel power menghubungkan sumber listrik ke power supply atau perangkat.', 'Ganti kabel power dengan yang baru. Periksa kondisi fisik kabel dari kerusakan atau terbakar. Gunakan kabel yang sesuai spesifikasi.', 'Kabel Power', 'assets/images/kabelpower.jpg'),
('K09', 'Kurang Daya Power Supply', 'Daya power supply tidak mencukupi untuk semua komponen.', 'Hitung total konsumsi daya komponen. Ganti dengan power supply yang wattage-nya lebih tinggi dan sesuai.', 'Power Supply', 'assets/images/powersupply.jpg'),
('K10', 'Port USB Rusak', 'Port USB adalah antarmuka untuk menghubungkan perangkat eksternal.', 'Coba port USB lain. Update driver USB di Device Manager. Cek di BIOS apakah USB enabled. Jika port fisik rusak, bawa ke teknisi.', 'Port USB', 'assets/images/usb.jpg'),
('K11', 'Keyboard Rusak', 'Keyboard adalah perangkat input utama untuk mengetik.', 'Coba keyboard di port lain. Test di komputer lain. Bersihkan keyboard dari debu. Jika tetap tidak terdeteksi, ganti keyboard baru.', 'Keyboard', 'assets/images/keyboard.jpg'),
('K12', 'Mouse Rusak', 'Mouse adalah perangkat input untuk mengendalikan kursor.', 'Coba mouse di port lain. Bersihkan sensor mouse. Test di komputer lain. Jika tetap tidak berfungsi, ganti mouse baru.', 'Mouse', 'assets/images/mouse.jpg'),
('K13', 'Motherboard Rusak', 'Motherboard adalah papan sirkuit utama yang menghubungkan semua komponen.', 'Cek kapasitor yang mengelembung atau terbakar. Periksa konektor daya. Jika ada kerusakan fisik, bawa ke teknisi atau ganti motherboard.', 'Motherboard', 'assets/images/motherboard.jpg'),
('K14', 'Charger Rusak', 'Charger adalah adaptor yang mengisi daya baterai laptop.', 'Coba charger lain yang kompatibel. Periksa kabel charger dari kerusakan fisik. Bersihkan port charging. Jika rusak, ganti charger original.', 'Charger', 'assets/images/charger.jpg'),
('K15', 'Kabel SATA/IDE Rusak', 'Kabel SATA/IDE menghubungkan storage drive ke motherboard.', 'Ganti kabel SATA/IDE dengan yang baru. Pastikan konektor terpasang dengan benar di kedua ujung. Coba port SATA lain di motherboard.', 'Kabel SATA/IDE', 'assets/images/sata.jpg'),
('K16', 'Power Supply, Motherboard, atau BIOS Rusak', 'Salah satu dari tiga komponen utama ini mengalami kerusakan.', 'Lakukan diagnosis satu per satu. Coba power supply di sistem lain. Cek baterai CMOS. Bawa ke teknisi untuk diagnosis lebih lanjut.', 'Power Supply / Motherboard / BIOS', 'assets/images/motherboard.jpg'),
('K17', 'BIOS Rusak', 'BIOS adalah firmware yang menginisialisasi hardware saat komputer dinyalakan.', 'Coba reset BIOS dengan mencabut baterai CMOS selama 10 menit. Jika ada opsi, flash/update BIOS. Jika gagal, bawa ke teknisi.', 'BIOS', 'assets/images/bios.jpg');

-- Seed Aturan
INSERT IGNORE INTO `tb_aturan` (`kode_kerusakan`, `kode_gejala`) VALUES
('K01', 'B01'), ('K01', 'B02'), ('K01', 'B24'),
('K02', 'B03'), ('K02', 'B05'), ('K02', 'B11'), ('K02', 'B12'),
('K03', 'B06'), ('K03', 'B07'), ('K03', 'B08'), ('K03', 'B19'), ('K03', 'B32'),
('K04', 'B01'), ('K04', 'B03'), ('K04', 'B09'), ('K04', 'B10'), ('K04', 'B12'), ('K04', 'B18'), ('K04', 'B24'), ('K04', 'B31'),
('K05', 'B10'), ('K05', 'B13'), ('K05', 'B14'),
('K06', 'B15'), ('K06', 'B16'), ('K06', 'B21'), ('K06', 'B29'), ('K06', 'B33'), ('K06', 'B36'),
('K07', 'B01'), ('K07', 'B03'), ('K07', 'B04'), ('K07', 'B05'), ('K07', 'B07'), ('K07', 'B09'), ('K07', 'B17'), ('K07', 'B18'), ('K07', 'B30'), ('K07', 'B33'),
('K08', 'B36'),
('K09', 'B15'), ('K09', 'B21'),
('K10', 'B10'),
('K11', 'B10'), ('K11', 'B22'), ('K11', 'B25'),
('K12', 'B10'), ('K12', 'B23'),
('K13', 'B26'), ('K13', 'B29'), ('K13', 'B34'), ('K13', 'B35'),
('K14', 'B27'), ('K14', 'B28'), ('K14', 'B30'),
('K15', 'B10'), ('K15', 'B19'),
('K16', 'B29'),
('K17', 'B01'), ('K17', 'B12'), ('K17', 'B29'), ('K17', 'B32'), ('K17', 'B35');
