import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/info_card.dart';
import '../widgets/code_chip.dart';
import '../data/data_pakar.dart';

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        constrainContent: true,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: AppSpacing.md),
                      const InfoCard(
                        icon: Icons.account_tree_rounded,
                        color: AppColors.success,
                        title: 'Metode',
                        description:
                            'Aplikasi ini menggunakan metode Forward Chaining, yaitu metode pencarian kesimpulan berdasarkan data atau fakta yang ada. Penelusuran dimulai dari fakta kemudian menuju kesimpulan.',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      InfoCard(
                        icon: Icons.dataset_rounded,
                        color: AppColors.warning,
                        title: 'Basis Pengetahuan',
                        description:
                            'Data gejala dan aturan diperoleh dari wawancara dengan Bapak Teguh Eko Nugroho, teknisi komputer di Bizmedia Computer dengan pengalaman lebih dari 20 tahun.\n\n'
                            '• ${semuaGejala.length} data gejala kerusakan\n'
                            '• ${semuaKerusakan.length} jenis kerusakan hardware\n'
                            '• ${aturan.length} aturan inferensi',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const InfoCard(
                        icon: Icons.code_rounded,
                        color: AppColors.primary,
                        title: 'Teknologi',
                        description:
                            'Dibangun menggunakan Flutter (Dart) — framework open source dari Google untuk pengembangan aplikasi mobile Android dan iOS.',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const InfoCard(
                        icon: Icons.school_rounded,
                        color: AppColors.secondary,
                        title: 'Referensi Penelitian',
                        description:
                            'Berdasarkan jurnal: "Penerapan Metode Forward Chaining Dalam Sistem Pakar Deteksi Kerusakan Hardware Komputer Berbasis Android"\n\n'
                            'Oleh: Rizal Fadilla & Teguh Wiharko\n'
                            'Universitas Sangga Buana YPKP Bandung\n'
                            'Digital Transformation Technology (Digitech), Vol.3 No.2, September 2023',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            AppColors.secondary.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo_icon.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.medical_services,
                color: AppColors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'PC DOCTOR',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Smart Hardware Diagnosis',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.md),
          const CodeChip(code: 'v1.0.0', label: 'Diagnostic Console'),
        ],
      ),
    );
  }
}
