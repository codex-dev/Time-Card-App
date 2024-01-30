import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:time_card_app/database/shifts_db.dart';
import 'package:time_card_app/model/shift.dart';

class DatabaseService {
  final dbName = 'shifts.db';

  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    final database = await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      await ShiftsDB().createTable(database);
    });
    return database;
  }
}
