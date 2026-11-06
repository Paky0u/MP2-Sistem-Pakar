import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/code_chip.dart';
import '../data/data_pakar.dart';
import '../models/kerusakan.dart';

class KamusScreen extends StatefulWidget {
  const KamusScreen({super.key});

  @override
  State<KamusScreen> createState() => _KamusScreenState();
}

class _KamusScreenState extends State<KamusScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = semuaKerusakan.where((k) {
      final q = _query.toLowerCase();
      return k.nama.toLowerCase().contains(q) ||
          k.hardware.toLowerCase().contains(q) ||
          k.deskripsi.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppBackground(
        constrainContent: true,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Kamus Kerusakan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
                child: TextField(
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari kerusakan atau hardware...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                          color: AppColors.surfaceBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                          color: AppColors.surfaceBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada hasil',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0,
                            AppSpacing.md, AppSpacing.lg),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: _KamusTile(kerusakan: filtered[index]),
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

class _KamusTile extends StatelessWidget {
  final Kerusakan kerusakan;
  const _KamusTile({required this.kerusakan});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => _showDetail(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CodeChip(code: kerusakan.kode, label: kerusakan.hardware),
              const Spacer(),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            kerusakan.nama,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            kerusakan.deskripsi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
                border:
                    Border(top: BorderSide(color: AppColors.surfaceBorder)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CodeChip(
                      code: kerusakan.kode, label: kerusakan.hardware),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    kerusakan.nama,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    kerusakan.deskripsi,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Solusi',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    kerusakan.solusi,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
