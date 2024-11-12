import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicamento.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medicamentos.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicamentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        dosagem TEXT NOT NULL,
        frequencia TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertMedicamento(Medicamento medicamento) async {
    final db = await instance.database;
    return await db.insert('medicamentos', medicamento.toMap());
  }

  Future<List<Medicamento>> getAllMedicamentos() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('medicamentos');
    return List.generate(maps.length, (i) => Medicamento.fromMap(maps[i]));
  }
} 