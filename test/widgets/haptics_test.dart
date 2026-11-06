import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/menu_card.dart';
import '../support/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mengetuk MenuCard memicu haptic feedback', (tester) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method.startsWith('HapticFeedback')) {
          calls.add(call);
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(PumpApp.widget(
      child: MenuCard(
        label: 'Diagnosis',
        icon: Icons.biotech,
        onTap: () {},
      ),
    ));

    await tester.tap(find.text('Diagnosis'));
    await tester.pumpAndSettle();

    expect(calls, isNotEmpty);
  });
}
