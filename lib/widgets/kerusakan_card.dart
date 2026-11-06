import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_counter.dart';

class KerusakanCard extends StatelessWidget {
  final String nama;
  final double persentase;
  final int? rank;
  final VoidCallback? onTap;

  const KerusakanCard({
    super.key,
    required this.nama,
    required this.persentase,
    this.rank,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentVal = (persentase * 100).toInt();
    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (rank != null) ...[
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: rank == 1
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surfaceBorder,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: rank == 1
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      color: rank == 1
                          ? AppColors.primary
                          : AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  nama,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  AnimatedCounter(
                    value: percentVal,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppFonts.mono,
                    ),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: AppFonts.mono,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: persentase,
              backgroundColor: AppColors.surfaceBorder,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
