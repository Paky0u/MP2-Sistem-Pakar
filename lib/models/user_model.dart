class UserModel {
  final int id;
  final String nama;
  final String email;
  final String role;
  final String? googleId;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.googleId,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id_user'] is int
          ? map['id_user']
          : int.tryParse(map['id_user']?.toString() ?? '0') ?? 0,
      nama: map['nama']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
      googleId: map['google_id']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': id,
      'nama': nama,
      'email': email,
      'role': role,
      'google_id': googleId,
    };
  }
}
