class Riwayat {
  final int? id;
  final String tanggal;
  final String gejalaDipilih; // Komma-separated atau JSON kode gejala
  final String kodeKerusakan;
  final String namaKerusakan;
  final int persentase;

  Riwayat({
    this.id,
    required this.tanggal,
    required this.gejalaDipilih,
    required this.kodeKerusakan,
    required this.namaKerusakan,
    required this.persentase,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_riwayat': id,
      'tanggal': tanggal,
      'gejala_dipilih': gejalaDipilih,
      'kode_kerusakan': kodeKerusakan,
      'nama_kerusakan': namaKerusakan,
      'persentase': persentase,
    };
  }

  factory Riwayat.fromMap(Map<String, dynamic> map) {
    return Riwayat(
      id: map['id_riwayat'] ?? map['id'],
      tanggal: map['tanggal']?.toString() ?? '',
      gejalaDipilih: (map['gejala_dipilih'] ?? map['gejalaDipilih'])?.toString() ?? '',
      kodeKerusakan: (map['kode_kerusakan'] ?? map['kodeKerusakan'])?.toString() ?? '',
      namaKerusakan: (map['nama_kerusakan'] ?? map['namaKerusakan'])?.toString() ?? '',
      persentase: map['persentase'] is int
          ? map['persentase']
          : int.tryParse(map['persentase']?.toString() ?? '0') ?? 0,
    );
  }
}
