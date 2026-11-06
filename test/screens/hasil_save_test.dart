import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/hasil_diagnosis_screen.dart';
import 'package:claude_v2/models/kerusakan.dart';
import 'package:claude_v2/models/riwayat.dart';
import '../support/pump_app.dart';

Kerusakan _kerusakan() => Kerusakan(
      'K01',
      'Monitor Rusak',
      'Monitor adalah perangkat output utama.',
      'Periksa kabel VGA/HDMI.',
      'Monitor',
      'assets/images/monitor.jpg',
    );

Map<String, dynamic> _hasil() => {
      'kerusakan': _kerusakan(),
      'persen': 95,
      'cocok': 3,
      'total': 3,
      'gejalaMatch': ['Layar blank', 'Garis di layar'],
    };

void main() {
  testWidgets('menyimpan hasil terbaik ke riwayat sekali', (tester) async {
    final saved = <Riwayat>[];

    await tester.pumpWidget(PumpApp.widget(
      child: HasilDiagnosisScreen(
        hasil: [_hasil()],
        gejalaTerpilih: const ['Layar blank', 'Garis di layar'],
        simpanRiwayat: (r) async {
          saved.add(r);
          return true;
        },
      ),
    ));
    await tester.pumpAndSettle();

    expect(saved.length, 1);
    expect(saved.first.namaKerusakan, 'Monitor Rusak');
    expect(saved.first.persentase, 95);
    expect(saved.first.gejalaDipilih, 'Layar blank, Garis di layar');
  });

  testWidgets('tidak menyimpan bila hasil kosong', (tester) async {
    var called = 0;

    await tester.pumpWidget(PumpApp.widget(
      child: HasilDiagnosisScreen(
        hasil: const [],
        simpanRiwayat: (r) async {
          called++;
          return true;
        },
      ),
    ));
    await tester.pumpAndSettle();

    expect(called, 0);
  });
}
