import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/skeleton.dart';
import '../services/api_service.dart';
import '../services/app_preferences.dart';
import '../models/riwayat.dart';
import '../models/user_model.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late Future<List<Riwayat>> _riwayatList;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _riwayatList = ApiService.getRiwayatList();
    _refreshRiwayat();
  }

  void _refreshRiwayat() async {
    try {
      final user = await AppPreferences.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
        _riwayatList = ApiService.getRiwayatList(
          idUser: user?.id,
          all: user?.isAdmin ?? false,
        );
      });
    } catch (_) {
      // In case SharedPreferences is unmocked in tests
    }
  }

  void _deleteItem(int id) async {
    final success = await ApiService.deleteRiwayat(id);
    if (success) {
      _refreshRiwayat();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riwayat dihapus')),
        );
      }
    }
  }

  void _confirmDeleteItem(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Hapus Riwayat?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data riwayat diagnosa ini?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteItem(id);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _clearAll() async {
    final success = await ApiService.deleteRiwayat(); // Tanpa ID = hapus semua
    if (success) {
      _refreshRiwayat();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua riwayat dibersihkan')),
        );
      }
    }
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Hapus Semua Riwayat?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Tindakan ini tidak dapat dibatalkan.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _clearAll();
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

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
                    AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Riwayat Diagnosis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (_currentUser != null)
                            Text(
                              _currentUser!.isAdmin
                                  ? 'Mode Admin: Menampilkan Semua Riwayat'
                                  : 'Riwayat Konsultasi Akun Anda',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus semua',
                      icon: const Icon(Icons.delete_sweep_rounded,
                          color: AppColors.danger),
                      onPressed: _confirmClearAll,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Riwayat>>(
                  future: _riwayatList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const _RiwayatSkeleton();
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const _EmptyState();
                    }

                    final list = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _RiwayatCard(
                            item: item,
                            showUserBadge: _currentUser?.isAdmin ?? false,
                            onDelete: () => _confirmDeleteItem(item.id!),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final Riwayat item;
  final bool showUserBadge;
  final VoidCallback onDelete;

  const _RiwayatCard({
    required this.item,
    this.showUserBadge = false,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.tanggal,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textMuted),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '${item.persentase}% Cocok',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (showUserBadge && item.namaUser != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 12, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'User: ${item.namaUser}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.namaKerusakan,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Gejala: ${item.gejalaDipilih}',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
          const Divider(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline,
                        size: 16, color: AppColors.danger),
                    SizedBox(width: 4),
                    Text('Hapus',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.danger)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_toggle_off,
              size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Belum ada riwayat',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Hasil diagnosis yang Anda simpan akan muncul di sini',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _RiwayatSkeleton extends StatelessWidget {
  const _RiwayatSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonLoader(width: 100, height: 12),
                    SkeletonLoader(width: 70, height: 18, radius: AppRadius.pill),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                SkeletonLoader(width: 180, height: 16),
                SizedBox(height: AppSpacing.xs),
                SkeletonLoader(width: double.infinity, height: 12),
                SizedBox(height: AppSpacing.xs),
                SkeletonLoader(width: 220, height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
