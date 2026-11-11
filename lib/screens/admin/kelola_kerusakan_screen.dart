import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_background.dart';
import '../../models/kerusakan.dart';
import '../../services/api_service.dart';
import '../../data/data_pakar.dart';

class KelolaKerusakanScreen extends StatefulWidget {
  const KelolaKerusakanScreen({super.key});

  @override
  State<KelolaKerusakanScreen> createState() => _KelolaKerusakanScreenState();
}

class _KelolaKerusakanScreenState extends State<KelolaKerusakanScreen> {
  List<Kerusakan> _kerusakanList = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchKerusakan();
  }

  Future<void> _fetchKerusakan() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getKerusakanList();
    if (mounted) {
      setState(() {
        _kerusakanList = data.isNotEmpty ? data : List.from(semuaKerusakan);
        _isLoading = false;
      });
    }
  }

  void _showFormDialog({Kerusakan? existing}) {
    final isEdit = existing != null;
    final kodeController = TextEditingController(text: existing?.kode ?? '');
    final namaController = TextEditingController(text: existing?.nama ?? '');
    final hardwareController = TextEditingController(text: existing?.hardware ?? '');
    final solusiController = TextEditingController(text: existing?.solusi ?? '');
    final deskripsiController = TextEditingController(text: existing?.deskripsi ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          isEdit ? 'Edit Kerusakan (${existing.kode})' : 'Tambah Kerusakan Baru',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEdit) ...[
                  const Text('Kode Kerusakan (misal: K18)',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: kodeController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'K18',
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Kode wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                ],
                const Text('Nama Kerusakan',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: namaController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Power Supply Rusak',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                const Text('Hardware / Komponen',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: hardwareController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Power Supply',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Hardware wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                const Text('Solusi / Penanganan',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: solusiController,
                  maxLines: 2,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Langkah perbaikan teknis...',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Solusi wajib diisi' : null,
                ),
                const SizedBox(height: 10),
                const Text('Deskripsi Komponen',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: deskripsiController,
                  maxLines: 2,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Penjelasan singkat tentang hardware...',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);

              final kode = isEdit ? existing.kode : kodeController.text.trim().toUpperCase();
              final nama = namaController.text.trim();
              final hardware = hardwareController.text.trim();
              final solusi = solusiController.text.trim();
              final deskripsi = deskripsiController.text.trim();

              Map<String, dynamic> res;
              if (isEdit) {
                res = await ApiService.updateKerusakan(
                  kode: kode,
                  nama: nama,
                  hardware: hardware,
                  solusi: solusi,
                  deskripsi: deskripsi,
                  imagePath: existing.imagePath,
                );
              } else {
                res = await ApiService.addKerusakan(
                  kode: kode,
                  nama: nama,
                  hardware: hardware,
                  solusi: solusi,
                  deskripsi: deskripsi,
                );
              }

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Berhasil diproses'),
                    backgroundColor: res['status'] == 'success' ? AppColors.success : AppColors.danger,
                  ),
                );
                _fetchKerusakan();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
            ),
            child: Text(isEdit ? 'Simpan' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Kerusakan k) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Konfirmasi Hapus', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Apakah Anda yakin ingin menghapus kerusakan [${k.kode}] "${k.nama}"?',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final res = await ApiService.deleteKerusakan(k.kode);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Berhasil dihapus'),
                    backgroundColor: res['status'] == 'success' ? AppColors.success : AppColors.danger,
                  ),
                );
                _fetchKerusakan();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _kerusakanList.where((k) {
      final q = _searchQuery.toLowerCase();
      return k.kode.toLowerCase().contains(q) ||
          k.nama.toLowerCase().contains(q) ||
          k.hardware.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Data Kerusakan'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kerusakan', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showFormDialog(),
      ),
      body: AppBackground(
        constrainContent: true,
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextField(
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari kode, nama kerusakan, hardware...',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.surfaceBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.surfaceBorder),
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),

              // Header Total
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${filtered.length} Kerusakan',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.primary, size: 20),
                      tooltip: 'Muat ulang',
                      onPressed: _fetchKerusakan,
                    ),
                  ],
                ),
              ),

              // List Kerusakan
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada data kerusakan ditemukan.',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 80),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  border: Border.all(color: AppColors.surfaceBorder),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(AppRadius.sm),
                                        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        item.kode,
                                        style: const TextStyle(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: AppFonts.mono,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.nama,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Hardware: ${item.hardware}',
                                            style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: AppColors.warning, size: 20),
                                      tooltip: 'Edit',
                                      onPressed: () => _showFormDialog(existing: item),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                                      tooltip: 'Hapus',
                                      onPressed: () => _confirmDelete(item),
                                    ),
                                  ],
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
}
