import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lab09.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Bảng tasks (Bài 1)
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isCompleted INTEGER
          )
        ''');

        // Bảng sinh_vien (Bài 2)
        await db.execute('''
          CREATE TABLE sinh_vien (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        ''');

        // Bảng chi_tieu (Bài 3)
        await db.execute('''
          CREATE TABLE chi_tieu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noiDung TEXT,
            soTien REAL,
            ghiChu TEXT
          )
        ''');

        // Bảng users (Bài 4)
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }
}