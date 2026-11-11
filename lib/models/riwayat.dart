class Riwayat {
  final int? id;
  final int? idUser;
  final String? namaUser;
  final String? emailUser;
  final String tanggal;
  final String gejalaDipilih; // Komma-separated atau JSON kode gejala
  final String kodeKerusakan;
  final String namaKerusakan;
  final int persentase;

  Riwayat({
    this.id,
    this.idUser,
    this.namaUser,
    this.emailUser,
    required this.tanggal,
    required this.gejalaDipilih,
    required this.kodeKerusakan,
    required this.namaKerusakan,
    required this.persentase,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_riwayat': id,
      'id_user': idUser,
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
      idUser: map['id_user'] != null
          ? (map['id_user'] is int
              ? map['id_user']
              : int.tryParse(map['id_user'].toString()))
          : null,
      namaUser: map['nama_user']?.toString(),
      emailUser: map['email_user']?.toString(),
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
