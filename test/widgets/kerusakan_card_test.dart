import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/kerusakan_card.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('KerusakanCard renders data', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const KerusakanCard(
        nama: 'RAM Rusak',
        persentase: 0.95,
      ),
    ));
    expect(find.text('RAM Rusak'), findsOneWidget);
    expect(find.text('95'), findsOneWidget);
    expect(find.text('%'), findsOneWidget);
  });
}
