import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/diagnosis_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('DiagnosisScreen renders', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const DiagnosisScreen()));
    expect(find.text('Pilih Gejala'), findsOneWidget);
  });
}
