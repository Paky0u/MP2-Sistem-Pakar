import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/radar_scan.dart';
import '../widgets/menu_card.dart';
import '../widgets/staggered_entrance.dart';
import '../widgets/code_chip.dart';
import '../utils/app_route.dart';
import 'diagnosis_screen.dart';
import 'kamus_screen.dart';
import 'riwayat_screen.dart';
import 'tentang_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: AppSpacing.maxContentWidth),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Icon(Icons.medical_services,
                                  color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PC DOCTOR',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  'Diagnostic Console',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const CodeChip(code: 'ONLINE', label: 'Sistem'),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        StaggeredEntrance(
                          index: 0,
                          child: SizedBox(
                            height: constraints.maxHeight > 700 ? 220 : 170,
                            width: constraints.maxHeight > 700 ? 220 : 170,
                            child: const RadarScan(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Text(
                          'SISTEM PAKAR KERUSAKAN HARDWARE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Deteksi dini kerusakan komputer dengan metode Forward Chaining',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                              constraints.maxWidth > 520 ? 4 : 2,
                          crossAxisSpacing: AppSpacing.sm,
                          mainAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 1.15,
                          children: [
                            StaggeredEntrance(
                              index: 1,
                              child: MenuCard(
                                label: 'Diagnosis',
                                icon: Icons.biotech,
                                glowColor: AppColors.primary,
                                onTap: () => Navigator.of(context).push(
                                    fadeSlideRoute(const DiagnosisScreen())),
                              ),
                            ),
                            StaggeredEntrance(
                              index: 2,
                              child: MenuCard(
                                label: 'Kamus',
                                icon: Icons.menu_book,
                                glowColor: AppColors.success,
                                onTap: () => Navigator.of(context).push(
                                    fadeSlideRoute(const KamusScreen())),
                              ),
                            ),
                            StaggeredEntrance(
                              index: 3,
                              child: MenuCard(
                                label: 'Riwayat',
                                icon: Icons.history,
                                glowColor: AppColors.warning,
                                onTap: () => Navigator.of(context).push(
                                    fadeSlideRoute(const RiwayatScreen())),
                              ),
                            ),
                            StaggeredEntrance(
                              index: 4,
                              child: MenuCard(
                                label: 'Tentang',
                                icon: Icons.info_outline,
                                glowColor: AppColors.secondary,
                                onTap: () => Navigator.of(context).push(
                                    fadeSlideRoute(const TentangScreen())),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
