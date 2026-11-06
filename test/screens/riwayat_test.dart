import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/riwayat_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('RiwayatScreen renders title', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const RiwayatScreen()));
    expect(find.text('Riwayat Diagnosis'), findsOneWidget);
  });
}
