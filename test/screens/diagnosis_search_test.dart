import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/diagnosis_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('pencarian gejala menyaring daftar', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const DiagnosisScreen()));

    await tester.enterText(find.byType(TextField), 'baterai');
    await tester.pumpAndSettle();

    expect(find.text('Baterai tidak mengisi daya saat di-charge'),
        findsOneWidget);
    expect(find.text('Layar blank saat komputer dinyalakan'), findsNothing);
  });
}
