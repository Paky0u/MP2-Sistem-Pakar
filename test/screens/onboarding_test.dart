import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/onboarding_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('Onboarding renders title and button', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const OnboardingScreen()));
    expect(find.text('PC DOCTOR'), findsOneWidget);
    expect(find.text('Mulai Diagnosis'), findsOneWidget);
  });
}
