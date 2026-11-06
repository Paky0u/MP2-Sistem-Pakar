import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/utils/app_system_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('menerapkan overlay status bar gelap', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await AppSystemUi.apply();

    expect(
      calls.any((c) => c.method == 'SystemChrome.setSystemUIOverlayStyle'),
      isTrue,
    );
  });
}
