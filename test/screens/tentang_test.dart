import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/screens/tentang_screen.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('TentangScreen renders title', (tester) async {
    await tester.pumpWidget(PumpApp.widget(child: const TentangScreen()));
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });
}
