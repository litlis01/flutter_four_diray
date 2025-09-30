import 'package:four_diary/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static late Database database;

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'pic_diary.db');
    print('DB 경로: $path');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE IF NOT EXISTS tb_diary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        imageTopLeft BLOB,
        imageTopRight BLOB,
        imageBtmLeft BLOB,
        imageBtmRight BLOB,
        date INTEGER
        )
        ''');
      },
    );
  }

  Future<int> insertInfo(DiaryModel diary) async {
    return await database.insert('tb_diary', diary.toMap());
  }

  Future<List<DiaryModel>> getAllInfo() async {
    final List<Map<String, dynamic>> result = await database.query(
      'tb_diary',
      orderBy: 'date DESC',
    );
    return List.generate(result.length, (index) {
      return DiaryModel.fromMap(result[index]);
    });
  }

  Future<int> updateInfo(DiaryModel diary) async {
    return await database.update(
      'tb_diary',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  Future<int> deleteInfo(int id) async {
    return await database.delete(
      'tb_diary',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    await database.close();
  }
}
