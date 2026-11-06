import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_preferences.dart';
import '../widgets/app_background.dart';
import '../widgets/gradient_button.dart';
import '../utils/app_route.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        constrainContent: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Spacer(),
                const Icon(Icons.medical_services, size: 80, color: AppColors.primary),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'PC DOCTOR',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Diagnostic Console',
                  style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                ),
                const Spacer(),
                GradientButton(
                  label: 'Mulai Diagnosis',
                  onPressed: () async {
                    await AppPreferences.setOnboardingDone();
                    if (!context.mounted) return;
                    Navigator.of(context)
                        .pushReplacement(fadeSlideRoute(const HomeScreen()));
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
