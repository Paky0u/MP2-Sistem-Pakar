import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'app_preferences.dart';

class AuthService {
  static const String googleClientId =
      '619624785000-s8v12npmoakg6adu4nh6mgmu90v1ervs.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? googleClientId : null,
    serverClientId: !kIsWeb ? googleClientId : null,
    scopes: ['email', 'profile'],
  );

  /// Login Manual
  static Future<Map<String, dynamic>> loginManual(
      String email, String password) async {
    final res = await ApiService.login(email, password);
    if (res['success'] == true && res['user'] != null) {
      await AppPreferences.saveUser(res['user'] as UserModel);
    }
    return res;
  }

  /// Register Akun Baru
  static Future<Map<String, dynamic>> register(
      String nama, String email, String password) async {
    return await ApiService.register(nama, email, password);
  }

  /// Login via Google Sign-In
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Pastikan session lama dibersihkan agar user bisa memilih akun
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        return {'success': false, 'message': 'Login Google dibatalkan.'};
      }

      final email = account.email;
      final nama = account.displayName ?? 'Pengguna Google';
      final googleId = account.id;

      final res = await ApiService.loginGoogle(
        email: email,
        nama: nama,
        googleId: googleId,
      );

      if (res['success'] == true && res['user'] != null) {
        await AppPreferences.saveUser(res['user'] as UserModel);
      }

      return res;
    } catch (e) {
      print('DEBUG: Error signInWithGoogle: $e');
      return {
        'success': false,
        'message': 'Gagal melakukan otentikasi Google: $e',
      };
    }
  }

  /// Logout
  static Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await AppPreferences.logout();
  }
}

