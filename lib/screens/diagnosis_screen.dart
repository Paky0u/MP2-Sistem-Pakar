import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/selection_ring.dart';
import '../utils/app_route.dart';
import '../data/data_pakar.dart';
import '../models/gejala.dart';
import '../services/inference_engine.dart';
import '../utils/app_haptics.dart';
import '../widgets/radar_scan.dart';
import 'hasil_diagnosis_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final Set<String> _selected = {};
  String _kategori = 'Semua';
  String _query = '';

  List<String> get _kategoriList {
    final set = <String>{'Semua'};
    for (final g in semuaGejala) {
      set.add(g.kategori);
    }
    return set.toList();
  }

  List<Gejala> get _filtered {
    var list = semuaGejala;
    if (_kategori != 'Semua') {
      list = list.where((g) => g.kategori == _kategori).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((g) =>
              g.nama.toLowerCase().contains(q) ||
              g.kode.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void _toggle(String kode) {
    AppHaptics.selection();
    setState(() {
      if (_selected.contains(kode)) {
        _selected.remove(kode);
      } else {
        _selected.add(kode);
      }
    });
  }

  void _proses() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu gejala terlebih dahulu'),
        ),
      );
      return;
    }

    AppHaptics.medium();

    // Tampilkan dialog scanning
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.surfaceBorder),
          ),
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: RadarScan(),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Menganalisis Sistem...',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Menerapkan aturan Forward Chaining...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulasi proses cerdas / delay radar
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    Navigator.of(context).pop(); // Tutup dialog

    final hasil = diagnosa(_selected);
    final list = (hasil['hasil'] as List).cast<Map<String, dynamic>>();
    final gejalaTerpilih = semuaGejala
        .where((g) => _selected.contains(g.kode))
        .map((g) => g.nama)
        .toList();

    Navigator.of(context).push(
      fadeSlideRoute(HasilDiagnosisScreen(
        hasil: list,
        gejalaTerpilih: gejalaTerpilih,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
                        'Pilih Gejala',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${_selected.length} dipilih',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                child: TextField(
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari gejala...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide:
                          const BorderSide(color: AppColors.surfaceBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide:
                          const BorderSide(color: AppColors.surfaceBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  itemCount: _kategoriList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final kat = _kategoriList[index];
                    final active = kat == _kategori;
                    return GestureDetector(
                      onTap: () => setState(() => _kategori = kat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: active
                                ? AppColors.primary
                                : AppColors.surfaceBorder,
                          ),
                        ),
                        child: Text(
                          kat,
                          style: TextStyle(
                            color: active
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: active
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final gejala = filtered[index];
                    final selected = _selected.contains(gejala.kode);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: SelectionRing(
                        selected: selected,
                        child: GlassCard(
                          padding: EdgeInsets.zero,
                          onTap: () => _toggle(gejala.kode),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.textMuted,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: selected
                                      ? const Icon(Icons.check,
                                          size: 16, color: Colors.black)
                                      : null,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gejala.nama,
                                        style: TextStyle(
                                          color: selected
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        gejala.kategori,
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
                child: GradientButton(
                  label: 'Diagnosa Sekarang',
                  icon: Icons.bolt,
                  onPressed: _selected.isEmpty ? null : _proses,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
