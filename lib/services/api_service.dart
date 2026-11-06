import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/riwayat.dart';

class ApiService {
  // Dinamis: 'localhost' untuk Web (Chrome) & Windows, '10.0.2.2' untuk Android Emulator
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://localhost/claude-v2/api';
    }
    return 'http://10.0.2.2/claude-v2/api';
  }

  static Future<List<Riwayat>> getRiwayatList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_riwayat.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Riwayat.fromMap(json)).toList();
      }
    } catch (e) {
      print('DEBUG: Error getRiwayatList: $e');
    }
    return [];
  }

  static Future<bool> simpanRiwayat(Riwayat riwayat) async {
    try {
      print('DEBUG: Mengirim data riwayat...');
      final response = await http.post(
        Uri.parse('$baseUrl/simpan_riwayat.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tanggal': riwayat.tanggal,
          'gejala_dipilih': riwayat.gejalaDipilih,
          'kode_kerusakan': riwayat.kodeKerusakan,
          'nama_kerusakan': riwayat.namaKerusakan,
          'persentase': riwayat.persentase,
        }),
      );
      print('DEBUG: Response Status: ${response.statusCode}');
      print('DEBUG: Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      print('DEBUG: Error Simpan Riwayat: $e');
    }
    return false;
  }

  static Future<bool> deleteRiwayat([int? id]) async {
    try {
      final url = id != null
          ? '$baseUrl/hapus_riwayat.php?id=$id'
          : '$baseUrl/hapus_riwayat.php';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      // Ignore / handle error
    }
    return false;
  }
}
