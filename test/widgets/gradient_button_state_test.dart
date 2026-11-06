import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/gradient_button.dart';
import 'package:claude_v2/theme/app_theme.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('label tombol disabled memakai warna muted yang terbaca',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const GradientButton(label: 'Diagnosa', onPressed: null),
    ));

    final text = tester.widget<Text>(find.text('Diagnosa'));
    expect(text.style?.color, AppColors.textMuted);
  });

  testWidgets('label tombol aktif memakai warna gelap di atas gradient',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: GradientButton(label: 'Diagnosa', onPressed: () {}),
    ));

    final text = tester.widget<Text>(find.text('Diagnosa'));
    expect(text.style?.color, Colors.black);
  });
}
