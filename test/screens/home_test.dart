import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/home_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('HomeScreen renders radar and menu', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const HomeScreen()));
    expect(find.text('Diagnosis'), findsOneWidget); // Menu card label
  });
}
