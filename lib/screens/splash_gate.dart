import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_preferences.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool? _onboardingDone;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final done = await AppPreferences.isOnboardingDone();
    if (!mounted) return;
    setState(() => _onboardingDone = done);
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingDone == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    return _onboardingDone! ? const HomeScreen() : const OnboardingScreen();
  }
}
