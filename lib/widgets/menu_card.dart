import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/press_scale.dart';

class MenuCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? glowColor;

  const MenuCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: GlassCard(
        glowColor: glowColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: glowColor ?? AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
