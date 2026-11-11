import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../widgets/app_background.dart';
import '../widgets/radar_scan.dart';
import '../widgets/menu_card.dart';
import '../widgets/staggered_entrance.dart';
import '../utils/app_route.dart';
import '../services/app_preferences.dart';
import '../services/auth_service.dart';
import 'diagnosis_screen.dart';
import 'kamus_screen.dart';
import 'riwayat_screen.dart';
import 'tentang_screen.dart';
import 'login_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AppPreferences.getUser();
    if (mounted) {
      setState(() => _user = user);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Konfirmasi Logout', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        fadeSlideRoute(const LoginScreen()),
        (route) => false,
      );
    }
  }

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
                        // Top Header Bar
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _user != null ? 'Halo, ${_user!.nama}' : 'PC DOCTOR',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _user != null ? _user!.email : 'Diagnostic Console',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (_user != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (_user!.isAdmin ? AppColors.warning : AppColors.primary)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  border: Border.all(
                                    color: (_user!.isAdmin ? AppColors.warning : AppColors.primary)
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  _user!.role.toUpperCase(),
                                  style: TextStyle(
                                    color: _user!.isAdmin ? AppColors.warning : AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.mono,
                                  ),
                                ),
                              ),
                            const SizedBox(width: AppSpacing.xs),
                            IconButton(
                              icon: const Icon(Icons.logout, color: AppColors.textMuted, size: 20),
                              tooltip: 'Logout',
                              onPressed: _handleLogout,
                            ),
                          ],
                        ),

                        // Jika login sebagai Admin, tampilkan banner shortcut ke Panel Admin
                        if (_user != null && _user!.isAdmin) ...[
                          const SizedBox(height: AppSpacing.md),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                fadeSlideRoute(const AdminDashboardScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: AppColors.warning.withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.admin_panel_settings, color: AppColors.warning, size: 18),
                                  SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      'Mode Pengguna • Ketuk untuk kembali ke Panel Admin',
                                      style: TextStyle(
                                        color: AppColors.warning,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: AppColors.warning, size: 12),
                                ],
                              ),
                            ),
                          ),
                        ],

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
