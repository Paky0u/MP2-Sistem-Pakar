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

  testWidgets('ke login screen bila onboarding selesai tapi belum login',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_selesai': true});
    await tester.pumpWidget(PumpApp.widget(child: const SplashGate()));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Akun'), findsOneWidget);
  });

  testWidgets('langsung ke home bila onboarding sudah selesai dan sudah login',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_selesai': true,
      'user_id': 1,
      'user_name': 'Test User',
      'user_email': 'test@gmail.com',
      'user_role': 'user',
    });
    await tester.pumpWidget(PumpApp.widget(child: const SplashGate()));
    await tester.pumpAndSettle();

    expect(find.text('SISTEM PAKAR KERUSAKAN HARDWARE'), findsOneWidget);
  });
}
