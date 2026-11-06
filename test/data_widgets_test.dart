import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/widgets/animated_counter.dart';
import 'package:claude_v2/widgets/code_chip.dart';
import 'package:claude_v2/widgets/radar_scan.dart';
import 'package:claude_v2/widgets/skeleton.dart';
import 'support/pump_app.dart';

void main() {
  testWidgets('AnimatedCounter shows value', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const AnimatedCounter(value: 85),
    ));
    expect(find.text('85'), findsOneWidget);
  });

  testWidgets('CodeChip shows label and code', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const CodeChip(code: 'CPU-01', label: 'Processor'),
    ));
    expect(find.text('CPU-01'), findsOneWidget);
    expect(find.text('Processor'), findsOneWidget);
  });

  testWidgets('RadarScan renders', (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const SizedBox(width: 200, height: 200, child: RadarScan()),
    ));
    expect(find.byType(RadarScan), findsOneWidget);
  });

  testWidgets('RadarScan berhenti beranimasi saat reduced motion',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const SizedBox(width: 200, height: 200, child: RadarScan()),
    ));
    // Tidak boleh timeout: tidak ada frame terjadwal terus-menerus.
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.byType(RadarScan), findsOneWidget);
  });

  testWidgets('SkeletonLoader berhenti beranimasi saat reduced motion',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      child: const SkeletonLoader(width: 100, height: 12),
    ));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.byType(SkeletonLoader), findsOneWidget);
  });
}
