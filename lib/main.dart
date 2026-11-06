import 'package:flutter/material.dart';
import 'screens/splash_gate.dart';
import 'theme/app_theme.dart';
import 'utils/app_system_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppSystemUi.apply();
  runApp(const SistemPakarApp());
}

class SistemPakarApp extends StatelessWidget {
  const SistemPakarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PC DOCTOR',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SplashGate(),
    );
  }
}
