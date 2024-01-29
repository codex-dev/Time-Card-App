import 'package:sqflite/sqflite.dart';
import 'package:time_card_app/database/database_service.dart';
import 'package:time_card_app/model/shift.dart';

class ShiftsDB {
  final tableName = 'shift';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        "shift_id" INTEGER NOT NULL,
        "work_date" TEXT NOT NULL,
        "employee_name" TEXT NOT NULL,
        "employee_email" TEXT NOT NULL,
        "check_in_time" TEXT NOT NULL,
        "check_out_time" TEXT,
        "hours" INTEGER,
        "hourly_rate" DOUBLE,
        "payment" DOUBLE,
        PRIMARY KEY("shift_id", AUTOINCREMENT)
      ); 
      """);
  }

  Future<int> addShift(
      {required String workDate,
      required String employeeName,
      required String employeeEmail,
      required String checkInTime}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
        '''INSERT INTO $tableName (work_date, employee_name, employee_email, check_in_time) VALUES (?,?,?,?)''',
        [workDate, employeeName, employeeEmail, checkInTime]);
  }

  Future<List<Shift>> getAllShiftsByDate({required String workDate}) async {
    final database = await DatabaseService().database;
    final shifts = await database.rawQuery(
        '''SELECT * FROM $tableName WHERE work_date=? ORDER BY shift_id ASC''',
        [workDate]);
    return shifts.map((shift) => Shift.fromSqfliteDatabase(shift)).toList();
  }

  Future<int> updateShift(
      {required int shiftId,
      String? checkInTime,
      String? checkOutTime,
      int? hours,
      double? hourlyRate,
      double? payment}) async {
    final database = await DatabaseService().database;
    return await database.update(
        tableName,
        {
          if (checkInTime != null) 'check_in_time': checkInTime,
          if (checkOutTime != null) 'check_out_time': checkOutTime,
          if (hours != null && hours > 0) 'hours': hours,
          if (hourlyRate != null && hourlyRate > 0) 'hourly_rate': hourlyRate,
          if (payment != null && payment > 0) 'payment': payment
        },
        where: 'shift_id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [shiftId]);
  }

  Future<void> deleteShift(int shiftId) async {
    final database = await DatabaseService().database;
    await database
        .rawDelete('''DELETE FROM $tableName WHERE shift_id = ?''', [shiftId]);
  }
}
