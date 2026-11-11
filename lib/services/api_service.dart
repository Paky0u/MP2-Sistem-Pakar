import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/riwayat.dart';
import '../models/user_model.dart';
import '../models/gejala.dart';
import '../models/kerusakan.dart';

class ApiService {
  // Dinamis: 'localhost' untuk Web (Chrome) & Windows, '10.0.2.2' untuk Android Emulator
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://localhost/claude-v2/api';
    }
    return 'http://10.0.2.2/claude-v2/api';
  }

  // --- AUTENTIKASI ---

  /// Login Manual menggunakan Email & Password
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['user'] != null) {
          return {
            'success': true,
            'message': data['message'] ?? 'Login berhasil.',
            'user': UserModel.fromMap(data['user']),
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Email atau password salah.',
          };
        }
      }
    } catch (e) {
      debugPrint('Error Login: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
    return {'success': false, 'message': 'Terjadi kesalahan sistem.'};
  }

  /// Pendaftaran Akun Baru (User)
  static Future<Map<String, dynamic>> register(
      String nama, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return {
            'success': true,
            'message': data['message'] ?? 'Pendaftaran berhasil.',
            'user': data['user'] != null ? UserModel.fromMap(data['user']) : null,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Pendaftaran gagal.',
          };
        }
      }
    } catch (e) {
      debugPrint('Error Register: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
    return {'success': false, 'message': 'Terjadi kesalahan sistem.'};
  }

  /// Login / Auto-Register via Google Sign-In
  static Future<Map<String, dynamic>> loginGoogle({
    required String email,
    required String nama,
    String? googleId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login_google.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'nama': nama,
          'google_id': googleId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['user'] != null) {
          return {
            'success': true,
            'message': data['message'] ?? 'Login Google berhasil.',
            'user': UserModel.fromMap(data['user']),
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login Google gagal.',
          };
        }
      }
    } catch (e) {
      debugPrint('Error Login Google: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
    return {'success': false, 'message': 'Terjadi kesalahan sistem.'};
  }

  // --- RIWAYAT ---

  static Future<List<Riwayat>> getRiwayatList({int? idUser, bool all = false}) async {
    try {
      String url = '$baseUrl/get_riwayat.php';
      if (all) {
        url += '?all=1';
      } else if (idUser != null && idUser > 0) {
        url += '?id_user=$idUser';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Riwayat.fromMap(json)).toList();
      }
    } catch (e) {
      debugPrint('Error getRiwayatList: $e');
    }
    return [];
  }

  static Future<bool> simpanRiwayat(Riwayat riwayat) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simpan_riwayat.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_user': riwayat.idUser,
          'tanggal': riwayat.tanggal,
          'gejala_dipilih': riwayat.gejalaDipilih,
          'kode_kerusakan': riwayat.kodeKerusakan,
          'nama_kerusakan': riwayat.namaKerusakan,
          'persentase': riwayat.persentase,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
    } catch (e) {
      debugPrint('Error Simpan Riwayat: $e');
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
      debugPrint('Error deleteRiwayat: $e');
    }
    return false;
  }

  // --- MANAJEMEN GEJALA (ADMIN CRUD) ---

  static Future<List<Gejala>> getGejalaList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_gejala.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => Gejala(
                  item['kode'].toString(),
                  item['nama'].toString(),
                ))
            .toList();
      }
    } catch (e) {
      debugPrint('Error getGejalaList: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> addGejala(String kode, String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_gejala.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'tambah',
          'kode_gejala': kode,
          'nama_gejala': nama,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Error addGejala: $e');
    }
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }

  static Future<Map<String, dynamic>> updateGejala(String kode, String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_gejala.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'edit',
          'kode_gejala': kode,
          'nama_gejala': nama,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Error updateGejala: $e');
    }
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }

  static Future<Map<String, dynamic>> deleteGejala(String kode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_gejala.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'hapus',
          'kode_gejala': kode,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Error deleteGejala: $e');
    }
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }

  // --- MANAJEMEN KERUSAKAN (ADMIN CRUD) ---

  static Future<List<Kerusakan>> getKerusakanList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_kerusakan.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => Kerusakan(
                  item['kode'].toString(),
                  item['nama'].toString(),
                  item['deskripsi'].toString(),
                  item['solusi'].toString(),
                  item['hardware'].toString(),
                  item['imagePath'].toString(),
                ))
            .toList();
      }
    } catch (e) {
      debugPrint('Error getKerusakanList: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> addKerusakan({
    required String kode,
    required String nama,
    required String deskripsi,
    required String solusi,
    required String hardware,
    String? imagePath,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_kerusakan.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'tambah',
          'kode_kerusakan': kode,
          'nama_kerusakan': nama,
          'deskripsi': deskripsi,
          'solusi': solusi,
          'hardware': hardware,
          'image_path': imagePath ?? 'assets/images/motherboard.jpg',
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Error addKerusakan: $e');
    }
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }

  static Future<Map<String, dynamic>> updateKerusakan({
    required String kode,
    required String nama,
    required String deskripsi,
    required String solusi,
    required String hardware,
    String? imagePath,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_kerusakan.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'edit',
          'kode_kerusakan': kode,
          'nama_kerusakan': nama,
          'deskripsi': deskripsi,
          'solusi': solusi,
          'hardware': hardware,
          'image_path': imagePath ?? 'assets/images/motherboard.jpg',
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Error updateKerusakan: $e');
    }
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }

  static Future<Map<String, dynamic>> deleteKerusakan(String kode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/manage_kerusakan.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'hapus',
          'kode_kerusakan': kode,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Error deleteKerusakan: $e');
    }
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }
}
