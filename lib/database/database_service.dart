import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:time_card_app/database/shifts_db.dart';

class DatabaseService {
  late Database _database;

  Future<Database> get database async {
    _database ??= await _initialize();
    return _database;
  }

  Future<String> get fullPath async {
    const name = 'shifts.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await ShiftsDB().createTable(database);
}
