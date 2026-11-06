import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:claude_v2/screens/splash_gate.dart';
import '../support/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('menampilkan onboarding saat pertama kali', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(PumpApp.widget(child: const SplashGate()));
    await tester.pumpAndSettle();

    expect(find.text('Mulai Diagnosis'), findsOneWidget);
  });

  testWidgets('langsung ke home bila onboarding sudah selesai',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_selesai': true});
    await tester.pumpWidget(PumpApp.widget(child: const SplashGate()));
    await tester.pumpAndSettle();

    expect(find.text('SISTEM PAKAR KERUSAKAN HARDWARE'), findsOneWidget);
  });
}
