import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:claude_v2/services/app_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('onboarding belum selesai secara default', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await AppPreferences.isOnboardingDone(), isFalse);
  });

  test('menandai onboarding selesai tersimpan', () async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.setOnboardingDone();
    expect(await AppPreferences.isOnboardingDone(), isTrue);
  });
}
