import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/theme/app_theme.dart';
import 'package:claude_v2/widgets/content_frame.dart';
import 'package:claude_v2/widgets/app_background.dart';
import '../support/pump_app.dart';

void main() {
  testWidgets('ContentFrame membatasi lebar konten di layar lebar',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      size: const Size(1200, 800),
      child: const ContentFrame(
        child: SizedBox(
          key: Key('inner'),
          width: double.infinity,
          height: 100,
        ),
      ),
    ));

    final size = tester.getSize(find.byKey(const Key('inner')));
    expect(size.width, AppSpacing.maxContentWidth);
  });

  testWidgets('AppBackground.constrainContent membatasi lebar anak',
      (tester) async {
    await tester.pumpWidget(PumpApp.widget(
      size: const Size(1200, 800),
      child: const AppBackground(
        constrainContent: true,
        child: SizedBox(
          key: Key('inner2'),
          width: double.infinity,
          height: 100,
        ),
      ),
    ));

    final size = tester.getSize(find.byKey(const Key('inner2')));
    expect(size.width, AppSpacing.maxContentWidth);
  });
}
