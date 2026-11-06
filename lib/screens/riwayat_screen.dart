import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/skeleton.dart';
import '../services/api_service.dart';
import '../models/riwayat.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late Future<List<Riwayat>> _riwayatList;

  @override
  void initState() {
    super.initState();
    _refreshRiwayat();
  }

  void _refreshRiwayat() {
    setState(() {
      _riwayatList = ApiService.getRiwayatList();
    });
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
                    const Expanded(
                      child: Text(
                        'Riwayat Diagnosis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
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
                            onDelete: () => _deleteItem(item.id!),
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
  final VoidCallback onDelete;

  const _RiwayatCard({required this.item, required this.onDelete});

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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: AppColors.textMuted),
          SizedBox(height: AppSpacing.md),
          Text(
            'Belum ada riwayat diagnosis',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
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
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 120, height: 12),
                SizedBox(height: AppSpacing.md),
                SkeletonLoader(width: 200, height: 18),
                SizedBox(height: AppSpacing.sm),
                SkeletonLoader(width: double.infinity, height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
