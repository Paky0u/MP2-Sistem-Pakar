import '../data/data_pakar.dart';

class HasilAturan {
  final String kodeKerusakan;
  final int jumlahCocok;
  final int totalKondisi;
  final int persenCocok;
  final List<String> gejalaCocok;
  HasilAturan(this.kodeKerusakan, this.jumlahCocok, this.totalKondisi,
      this.persenCocok, this.gejalaCocok);
}

Map<String, dynamic> diagnosa(Set<String> gejalaTerpilih) {
  List<HasilAturan> kandidat = [];

  for (final r in aturan) {
    final cocok = r.kondisi.where((k) => gejalaTerpilih.contains(k)).toList();
    final jumlah = cocok.length;
    final total = r.kondisi.length;

    // Aturan 1 kondisi: harus 100% cocok
    if (total == 1) {
      if (jumlah == 1) {
        kandidat.add(HasilAturan(r.hasil, jumlah, total, 100, cocok));
      }
      continue;
    }

    // Aturan 2 kondisi: harus cocok semua (100%)
    if (total == 2) {
      if (jumlah == 2) {
        kandidat.add(HasilAturan(r.hasil, jumlah, total, 100, cocok));
      }
      continue;
    }

    // Aturan 3+ kondisi: minimal 60% atau minimal 2 gejala cocok
    final persen = (jumlah * 100) ~/ total;
    if (persen >= 60 || jumlah >= 2) {
      kandidat.add(HasilAturan(r.hasil, jumlah, total, persen, cocok));
    }
  }

  // Hapus duplikat kode kerusakan (ambil yang persentase tertinggi)
  final Map<String, HasilAturan> best = {};
  for (final h in kandidat) {
    if (!best.containsKey(h.kodeKerusakan) ||
        h.persenCocok > best[h.kodeKerusakan]!.persenCocok) {
      best[h.kodeKerusakan] = h;
    }
  }

  // Urutkan dari persentase tertinggi
  final sorted = best.values.toList()
    ..sort((a, b) => b.persenCocok.compareTo(a.persenCocok));

  // Bangun hasil lengkap
  final List<Map<String, dynamic>> hasilLengkap = sorted.map((h) {
    final kerusakan = semuaKerusakan.firstWhere(
        (ke) => ke.kode == h.kodeKerusakan,
        orElse: () => semuaKerusakan[0]);
    final gejalaNama = semuaGejala
        .where((g) => h.gejalaCocok.contains(g.kode))
        .map((g) => g.nama)
        .toList();
    return {
      'kerusakan': kerusakan,
      'persen': h.persenCocok,
      'cocok': h.jumlahCocok,
      'total': h.totalKondisi,
      'gejalaMatch': gejalaNama,
    };
  }).toList();

  return {'hasil': hasilLengkap};
}
