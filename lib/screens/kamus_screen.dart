import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/code_chip.dart';
import '../data/data_pakar.dart';
import '../models/kerusakan.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/app_preferences.dart';

class KamusScreen extends StatefulWidget {
  const KamusScreen({super.key});

  @override
  State<KamusScreen> createState() => _KamusScreenState();
}

class _KamusScreenState extends State<KamusScreen> {
  String _query = '';
  List<Kerusakan> _kerusakanList = [];
  bool _isLoading = true;
  UserModel? _user;

  bool get _isAdmin => _user?.isAdmin ?? false;

  @override
  void initState() {
    super.initState();
    _loadUserAndData();
  }

  Future<void> _loadUserAndData() async {
    try {
      final user = await AppPreferences.getUser();
      if (mounted) {
        setState(() => _user = user);
      }
    } catch (_) {}
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
    final hardwareController =
        TextEditingController(text: existing?.hardware ?? '');
    final solusiController =
        TextEditingController(text: existing?.solusi ?? '');
    final deskripsiController =
        TextEditingController(text: existing?.deskripsi ?? '');
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
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: kodeController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'K18',
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Kode wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 10),
                ],
                const Text('Nama Kerusakan',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: namaController,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Power Supply Rusak',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                const Text('Hardware / Komponen',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: hardwareController,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Contoh: Power Supply',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Hardware wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                const Text('Solusi / Penanganan',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: solusiController,
                  maxLines: 2,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Langkah perbaikan teknis...',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Solusi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 10),
                const Text('Deskripsi Komponen',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: deskripsiController,
                  maxLines: 2,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Penjelasan singkat tentang hardware...',
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);

              final kode = isEdit
                  ? existing.kode
                  : kodeController.text.trim().toUpperCase();
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
                    backgroundColor: res['status'] == 'success'
                        ? AppColors.success
                        : AppColors.danger,
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
        title: const Text('Konfirmasi Hapus',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Apakah Anda yakin ingin menghapus data kerusakan [${k.kode}] "${k.nama}" dari kamus?',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final res = await ApiService.deleteKerusakan(k.kode);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Berhasil dihapus'),
                    backgroundColor: res['status'] == 'success'
                        ? AppColors.success
                        : AppColors.danger,
                  ),
                );
                _fetchKerusakan();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _kerusakanList.where((k) {
      final q = _query.toLowerCase();
      return k.nama.toLowerCase().contains(q) ||
          k.hardware.toLowerCase().contains(q) ||
          k.deskripsi.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showFormDialog(),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kerusakan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : null,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kamus Kerusakan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (_isAdmin)
                            const Text(
                              'Mode Admin: Anda dapat Menambah, Mengedit, dan Menghapus',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.secondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_isAdmin)
                      IconButton(
                        tooltip: 'Tambah Kerusakan',
                        icon: const Icon(Icons.add_circle,
                            color: AppColors.primary, size: 28),
                        onPressed: () => _showFormDialog(),
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
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      )
                    : filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada hasil',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: _KamusTile(
                                  kerusakan: item,
                                  isAdmin: _isAdmin,
                                  onEdit: () =>
                                      _showFormDialog(existing: item),
                                  onDelete: () => _confirmDelete(item),
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

class _KamusTile extends StatelessWidget {
  final Kerusakan kerusakan;
  final bool isAdmin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KamusTile({
    required this.kerusakan,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
  });

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
              if (isAdmin) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      size: 18, color: AppColors.primary),
                  tooltip: 'Edit Kerusakan',
                  constraints: const BoxConstraints(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: AppColors.danger),
                  tooltip: 'Hapus Kerusakan',
                  constraints: const BoxConstraints(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  onPressed: onDelete,
                ),
              ] else ...[
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
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
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CodeChip(
                          code: kerusakan.kode, label: kerusakan.hardware),
                      if (isAdmin)
                        Row(
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.edit, size: 14),
                              label: const Text('Edit'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                    color: AppColors.primary),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                onEdit();
                              },
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.delete, size: 14),
                              label: const Text('Hapus'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: const BorderSide(color: AppColors.danger),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                onDelete();
                              },
                            ),
                          ],
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
