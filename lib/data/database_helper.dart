import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/riwayat.dart';
import 'data_pakar.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diagnos_pc.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Table Gejala
    await db.execute('''
      CREATE TABLE tb_gejala (
        kode_gejala TEXT PRIMARY KEY,
        nama_gejala TEXT NOT NULL
      )
    ''');

    // 2. Table Kerusakan
    await db.execute('''
      CREATE TABLE tb_kerusakan (
        kode_kerusakan TEXT PRIMARY KEY,
        nama_kerusakan TEXT NOT NULL,
        deskripsi TEXT NOT NULL,
        solusi TEXT NOT NULL,
        hardware TEXT NOT NULL,
        image_path TEXT NOT NULL
      )
    ''');

    // 3. Table Aturan
    await db.execute('''
      CREATE TABLE tb_aturan (
        id_aturan INTEGER PRIMARY KEY AUTOINCREMENT,
        kode_kerusakan TEXT NOT NULL,
        kode_gejala TEXT NOT NULL,
        FOREIGN KEY (kode_kerusakan) REFERENCES tb_kerusakan (kode_kerusakan),
        FOREIGN KEY (kode_gejala) REFERENCES tb_gejala (kode_gejala)
      )
    ''');

    // 4. Table Riwayat
    await db.execute('''
      CREATE TABLE tb_riwayat (
        id_riwayat INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        gejala_dipilih TEXT NOT NULL,
        kode_kerusakan TEXT NOT NULL,
        nama_kerusakan TEXT NOT NULL,
        persentase INTEGER NOT NULL
      )
    ''');

    // Seed Data
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Insert Gejala
    for (var g in semuaGejala) {
      await db.insert('tb_gejala', {
        'kode_gejala': g.kode,
        'nama_gejala': g.nama,
      });
    }

    // Insert Kerusakan
    for (var k in semuaKerusakan) {
      await db.insert('tb_kerusakan', {
        'kode_kerusakan': k.kode,
        'nama_kerusakan': k.nama,
        'deskripsi': k.deskripsi,
        'solusi': k.solusi,
        'hardware': k.hardware,
        'image_path': k.imagePath,
      });
    }

    // Insert Aturan
    for (var a in aturan) {
      for (var k in a.kondisi) {
        await db.insert('tb_aturan', {
          'kode_kerusakan': a.hasil,
          'kode_gejala': k,
        });
      }
    }
  }

  // --- CRUD RIWAYAT ---
  Future<int> insertRiwayat(Riwayat riwayat) async {
    final db = await instance.database;
    return await db.insert('tb_riwayat', riwayat.toMap());
  }

  Future<List<Riwayat>> getRiwayatList() async {
    final db = await instance.database;
    final result = await db.query('tb_riwayat', orderBy: 'id_riwayat DESC');
    return result.map((json) => Riwayat.fromMap(json)).toList();
  }

  Future<int> deleteRiwayat(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tb_riwayat',
      where: 'id_riwayat = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearAllRiwayat() async {
    final db = await instance.database;
    return await db.delete('tb_riwayat');
  }
}
