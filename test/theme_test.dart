import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claude_v2/theme/app_theme.dart';

void main() {
  test('App theme brightness and colors', () {
    final theme = buildAppTheme();
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
  });
}
