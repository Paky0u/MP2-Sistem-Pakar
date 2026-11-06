import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/code_chip.dart';
import 'package:claude_v2/widgets/kerusakan_card.dart';
import 'package:claude_v2/theme/app_theme.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('CodeChip memakai font monospace console', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const CodeChip(code: 'CPU-01', label: 'Processor'),
    ));
    final text = tester.widget<Text>(find.text('CPU-01'));
    expect(text.style?.fontFamily, AppFonts.mono);
  });

  testWidgets('persentase KerusakanCard memakai font monospace',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const KerusakanCard(nama: 'RAM Rusak', persentase: 0.95),
    ));
    final text = tester.widget<Text>(find.text('95'));
    expect(text.style?.fontFamily, AppFonts.mono);
  });
}
