import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/hasil_diagnosis_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('HasilDiagnosisScreen renders', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const HasilDiagnosisScreen(
      hasil: [],
    )));
    expect(find.text('Hasil Diagnosis'), findsOneWidget);
  });
}
