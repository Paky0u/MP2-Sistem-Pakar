import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/glass_card.dart';
import 'package:claude_v2/widgets/gradient_button.dart';
import 'support/pump_app.dart';

void main() {
  testWidgets('GlassCard renders child', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const GlassCard(child: Text('test')),
    ));
    expect(find.text('test'), findsOneWidget);
  });

  testWidgets('GradientButton renders label and icon', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const GradientButton(label: 'Submit', icon: Icons.send),
    ));
    expect(find.text('Submit'), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}
