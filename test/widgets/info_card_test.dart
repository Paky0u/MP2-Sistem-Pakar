import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/info_card.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('InfoCard renders title and description', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const InfoCard(
        title: 'Forward Chaining',
        description: 'Metode inferensi.',
        icon: Icons.psychology,
      ),
    ));
    expect(find.text('Forward Chaining'), findsOneWidget);
    expect(find.text('Metode inferensi.'), findsOneWidget);
  });
}
