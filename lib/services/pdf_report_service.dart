import 'dart:typed_data';
// ignore_for_file: prefer_const_constructors
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportService {
  /// Membuat dan menampilkan / mengunduh file PDF Laporan Diagnosis
  static Future<void> printDiagnosisReport({
    required String namaUser,
    required String emailUser,
    required String tanggal,
    required String namaKerusakan,
    required String kodeKerusakan,
    required String hardware,
    required int persentase,
    required String deskripsi,
    required String solusi,
    required List<String> gejalaList,
    List<Map<String, dynamic>> daftarKerusakanLain = const [],
  }) async {
    final pdfBytes = await generateDiagnosisPdf(
      namaUser: namaUser,
      emailUser: emailUser,
      tanggal: tanggal,
      namaKerusakan: namaKerusakan,
      kodeKerusakan: kodeKerusakan,
      hardware: hardware,
      persentase: persentase,
      deskripsi: deskripsi,
      solusi: solusi,
      gejalaList: gejalaList,
      daftarKerusakanLain: daftarKerusakanLain,
    );

    await Printing.layoutPdf(
      name:
          'Laporan_Diagnosa_${kodeKerusakan}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  /// Menghasilkan Uint8List dokumen PDF dengan dukungan multi-halaman otomatis
  static Future<Uint8List> generateDiagnosisPdf({
    required String namaUser,
    required String emailUser,
    required String tanggal,
    required String namaKerusakan,
    required String kodeKerusakan,
    required String hardware,
    required int persentase,
    required String deskripsi,
    required String solusi,
    required List<String> gejalaList,
    List<Map<String, dynamic>> daftarKerusakanLain = const [],
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'PC DOCTOR',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.cyan900,
                        ),
                      ),
                      pw.Text(
                        'SISTEM PAKAR DIAGNOSIS KERUSAKAN HARDWARE KOMPUTER',
                        style: const pw.TextStyle(
                          fontSize: 8.5,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.Text(
                        'Metode Inferensi: Forward Chaining',
                        style: pw.TextStyle(
                          fontSize: 8.5,
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      border:
                          pw.Border.all(color: PdfColors.cyan700, width: 1.5),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      'HASIL DIAGNOSIS',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.cyan900,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Divider(thickness: 1.2, color: PdfColors.cyan800),
              pw.SizedBox(height: 8),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'PC DOCTOR Expert System - Metode Forward Chaining',
                    style: const pw.TextStyle(
                        fontSize: 7.5, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                    style: const pw.TextStyle(
                        fontSize: 7.5, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            // Metadata Pemeriksaan
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildMetaRow('Nama Pengguna',
                          namaUser.isNotEmpty ? namaUser : 'Tamu'),
                      _buildMetaRow(
                          'Email Akun', emailUser.isNotEmpty ? emailUser : '-'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildMetaRow('Waktu Diagnosis', tanggal),
                      _buildMetaRow('Metode Inferensi', 'Forward Chaining'),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // Section 1: Gejala yang Terdeteksi
            pw.Text(
              '1. FAKTA GEJALA YANG DIPILIH PENGGUNA',
              style: pw.TextStyle(
                fontSize: 10.5,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey900,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: gejalaList.isEmpty
                  ? pw.Text('Tidak ada gejala spesifik tercatat.',
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColors.grey600))
                  : pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: gejalaList.asMap().entries.map((entry) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 3),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('${entry.key + 1}. ',
                                  style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Expanded(
                                child: pw.Text(entry.value,
                                    style: const pw.TextStyle(fontSize: 9)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            pw.SizedBox(height: 14),

            // Section 2: Diagnosa Utama
            pw.Text(
              '2. DIAGNOSA UTAMA (HASIL INFERENSI TERTINGGI)',
              style: pw.TextStyle(
                fontSize: 10.5,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey900,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.cyan50,
                border: pw.Border.all(color: PdfColors.cyan600),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '$namaKerusakan ($kodeKerusakan)',
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.cyan900,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Hardware Terkait: $hardware',
                        style: const pw.TextStyle(
                          fontSize: 9.5,
                          color: PdfColors.blueGrey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.cyan700,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          '$persentase%',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.Text(
                          'Peringkat #1',
                          style: const pw.TextStyle(
                            fontSize: 7.5,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            // Deskripsi Kerusakan Utama
            if (deskripsi.isNotEmpty && deskripsi != '-') ...[
              pw.Text(
                'Deskripsi Masalah:',
                style:
                    pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                deskripsi,
                style: const pw.TextStyle(
                    fontSize: 8.5, color: PdfColors.grey800, lineSpacing: 1.5),
              ),
              pw.SizedBox(height: 8),
            ],

            // Solusi & Penanganan Utama
            pw.Text(
              'Rekomendasi Tindakan & Solusi Utama:',
              style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900),
            ),
            pw.SizedBox(height: 2),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                solusi,
                style: const pw.TextStyle(
                  fontSize: 8.5,
                  color: PdfColors.grey900,
                  lineSpacing: 1.8,
                ),
              ),
            ),
            pw.SizedBox(height: 14),

            // Section 3: Kemungkinan Kerusakan Alternatif (Jika ada lebih dari 1)
            if (daftarKerusakanLain.isNotEmpty) ...[
              pw.Text(
                '3. DIAGNOSA BANDING / KEMUNGKINAN KERUSAKAN LAINNYA',
                style: pw.TextStyle(
                  fontSize: 10.5,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Berdasarkan penelusuran Forward Chaining, aturan berikut juga terpicu oleh gejala yang dipilih:',
                style: const pw.TextStyle(
                    fontSize: 8,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 6),
              pw.Column(
                children: daftarKerusakanLain.asMap().entries.map((entry) {
                  final idx = entry.key + 2; // Mulai dari peringkat #2
                  final k = entry.value;
                  final kNama = k['nama']?.toString() ?? '-';
                  final kKode = k['kode']?.toString() ?? '-';
                  final kHardware = k['hardware']?.toString() ?? '-';
                  final kPersen = k['persen']?.toString() ?? '0';
                  final kSolusi = k['solusi']?.toString() ?? '';

                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 6),
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment:
                              pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Row(
                              children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: pw.BoxDecoration(
                                    color: PdfColors.blueGrey700,
                                    borderRadius: pw.BorderRadius.circular(4),
                                  ),
                                  child: pw.Text(
                                    'Peringkat #$idx',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Text(
                                  '$kNama ($kKode)',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.blueGrey900,
                                  ),
                                ),
                              ],
                            ),
                            pw.Text(
                              '$kPersen% Cocok',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.cyan800,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Hardware Terkait: $kHardware',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),
                        if (kSolusi.isNotEmpty && kSolusi != '-') ...[
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Saran Solusi: $kSolusi',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey800,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 14),
            ],

            // Disclaimer & Penandatanganan
            pw.Divider(color: PdfColors.grey400),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '* Laporan ini di-generate secara otomatis oleh Sistem Pakar.',
                      style: const pw.TextStyle(
                          fontSize: 7.5, color: PdfColors.grey600),
                    ),
                    pw.Text(
                      '  Metode: Forward Chaining (Deteksi Dini Kerusakan Komputer)',
                      style: const pw.TextStyle(
                          fontSize: 7.5, color: PdfColors.grey600),
                    ),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Pemeriksa / Sistem Pakar,',
                        style: const pw.TextStyle(fontSize: 8.5)),
                    pw.SizedBox(height: 25),
                    pw.Text('PC DOCTOR EXPERT SYSTEM',
                        style: pw.TextStyle(
                            fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildMetaRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 85,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800),
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey900),
          ),
        ],
      ),
    );
  }
}
