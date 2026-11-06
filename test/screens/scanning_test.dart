import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/diagnosis_screen.dart';
import 'package:claude_v2/widgets/glass_card.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('menekan tombol diagnosa menampilkan dialog/animasi scanning',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const DiagnosisScreen()));

    // Pilih minimal satu gejala agar tombol aktif
    // Pilih gejala pertama
    await tester.tap(find.byType(GlassCard).at(0));
    await tester.pump();

    // Tap tombol diagnosa
    await tester.tap(find.text('Diagnosa Sekarang'));
    await tester.pump(); // frame pertama animasi scanning

    expect(find.text('Menganalisis Sistem...'), findsOneWidget);

    // Selesaikan delay scanning agar tidak ada timer menggantung
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  });
}
