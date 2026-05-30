import '../models/expense.dart';
import '../utils/database_helper.dart';

class ChiTieuController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insert(ChiTieu item) async {
    final db = await _dbHelper.database;
    final map = item.toMap()..remove('id');
    await db.insert('chi_tieu', map);
  }

  Future<void> update(ChiTieu item) async {
    final db = await _dbHelper.database;
    await db.update(
      'chi_tieu',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('chi_tieu', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ChiTieu>> fetchAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query('chi_tieu', orderBy: 'id DESC');
    return maps.map((e) => ChiTieu.fromMap(e)).toList();
  }

  Future<double> tongChiTieu() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
        'SELECT SUM(soTien) as total FROM chi_tieu');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}