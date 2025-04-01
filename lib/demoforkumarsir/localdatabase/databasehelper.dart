import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'qrcodes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,  // ✅ Ensures the table is created
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qrcodes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE
      )
    ''');
    print("✅ Table 'qrcodes' created successfully.");
  }

  Future<int> insertQR(String code) async {
    final db = await database;
    return await db.insert(
      'qrcodes',
      {'code': code},
      conflictAlgorithm: ConflictAlgorithm.ignore,  // Avoid duplicate inserts
    );
  }

  Future<List<String>> getAllQRs() async {
    final db = await database;
    final result = await db.query('qrcodes');

    return result.map((row) => row['code'] as String).toList();
  }
}
