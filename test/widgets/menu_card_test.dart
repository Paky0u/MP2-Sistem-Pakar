import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/menu_card.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('MenuCard renders label and icon', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: MenuCard(
        label: 'Diagnosis',
        icon: Icons.search,
        onTap: () {},
      ),
    ));
    expect(find.text('Diagnosis'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
