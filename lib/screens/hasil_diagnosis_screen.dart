import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/kerusakan_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/code_chip.dart';
import '../models/kerusakan.dart';
import '../models/riwayat.dart';
import '../services/api_service.dart';

class HasilDiagnosisScreen extends StatefulWidget {
  /// Hasil dari `diagnosa()` pada inference_engine:
  /// [{ 'kerusakan': Kerusakan, 'persen': int, 'cocok': int,
  ///    'total': int, 'gejalaMatch': List<String> }]
  final List<Map<String, dynamic>> hasil;
  final List<String> gejalaTerpilih;

  /// Dapat di-inject pada pengujian; default memakai ApiService.
  final Future<bool> Function(Riwayat)? simpanRiwayat;

  const HasilDiagnosisScreen({
    super.key,
    required this.hasil,
    this.gejalaTerpilih = const [],
    this.simpanRiwayat,
  });

  @override
  State<HasilDiagnosisScreen> createState() => _HasilDiagnosisScreenState();
}

class _HasilDiagnosisScreenState extends State<HasilDiagnosisScreen> {
  @override
  void initState() {
    super.initState();
    _simpanKeRiwayat();
  }

  Future<void> _simpanKeRiwayat() async {
    if (widget.hasil.isEmpty) return;

    final item = widget.hasil.first;
    final kerusakan = item['kerusakan'] as Kerusakan;
    final gejala = widget.gejalaTerpilih.isNotEmpty
        ? widget.gejalaTerpilih
        : (item['gejalaMatch'] as List).cast<String>();

    final riwayat = Riwayat(
      tanggal: _formatTanggal(DateTime.now()),
      gejalaDipilih: gejala.join(', '),
      kodeKerusakan: kerusakan.kode,
      namaKerusakan: kerusakan.nama,
      persentase: item['persen'] as int,
    );

    final saver = widget.simpanRiwayat ?? ApiService.simpanRiwayat;
    await saver(riwayat);
  }

  String _formatTanggal(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} '
        '${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasil = widget.hasil;
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
                    const Expanded(
                      child: Text(
                        'Hasil Diagnosis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: hasil.isEmpty
                    ? const _EmptyResult()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
                        itemCount: hasil.length,
                        itemBuilder: (context, index) {
                          final item = hasil[index];
                          final kerusakan =
                              item['kerusakan'] as Kerusakan;
                          final persen = (item['persen'] as int) / 100.0;
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: KerusakanCard(
                              nama: kerusakan.nama,
                              persentase: persen,
                              rank: index + 1,
                              onTap: () =>
                                  _showDetail(context, item, index + 1),
                            ),
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

  void _showDetail(
      BuildContext context, Map<String, dynamic> item, int rank) {
    final kerusakan = item['kerusakan'] as Kerusakan;
    final gejalaMatch = (item['gejalaMatch'] as List).cast<String>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
                border: Border(
                    top: BorderSide(color: AppColors.surfaceBorder)),
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
                  Row(
                    children: [
                      CodeChip(
                        code: kerusakan.kode,
                        label: 'Peringkat #$rank',
                      ),
                      const Spacer(),
                      Text(
                        '${item['persen']}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                  _Section(
                    title: 'Gejala Cocok',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: gejalaMatch
                          .map((g) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.xs),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: AppColors.success, size: 16),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        g,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Section(
                    title: 'Solusi',
                    child: Text(
                      kerusakan.solusi,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
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

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline,
              size: 64, color: AppColors.textMuted),
          SizedBox(height: AppSpacing.md),
          Text(
            'Tidak ada kerusakan terdeteksi',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
