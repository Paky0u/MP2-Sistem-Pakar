import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../services/app_preferences.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool? _onboardingDone;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final done = await AppPreferences.isOnboardingDone();
    UserModel? user;
    if (done) {
      user = await AppPreferences.getUser();
    }
    if (!mounted) return;
    setState(() {
      _onboardingDone = done;
      _currentUser = user;
    });
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

    if (!_onboardingDone!) {
      return const OnboardingScreen();
    }

    if (_currentUser == null) {
      return const LoginScreen();
    }

    return _currentUser!.isAdmin
        ? const AdminDashboardScreen()
        : const HomeScreen();
  }
}
