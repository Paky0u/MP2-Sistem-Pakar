import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/kamus_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('KamusScreen renders title', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const KamusScreen()));
    expect(find.text('Kamus Kerusakan'), findsOneWidget);
  });
}
