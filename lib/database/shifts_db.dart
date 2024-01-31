import 'package:sqflite/sqflite.dart';
import 'package:time_card_app/database/database_service.dart';
import 'package:time_card_app/model/shift.dart';

class ShiftsDB {
  final _tableName = 'shift';
  final _columnShiftId = 'shift_id';
  final _columnWorkDate = 'work_date';
  final _columnEmployeeName = 'employee_name';
  final _columnEmployeeEmail = 'employee_email';
  final _columnCheckInTime = 'check_in_time';
  final _columnCheckOutTime = 'check_out_time';
  final _columnHours = 'hours';
  final _columnHourlyRate = 'hourly_rate';
  final _columnPayment = 'payment';

  Future<void> createTable(Database database) async {
    await database.execute('''
CREATE TABLE IF NOT EXISTS $_tableName(
$_columnShiftId INTEGER PRIMARY KEY AUTOINCREMENT,
$_columnWorkDate TEXT NOT NULL, 
$_columnEmployeeName TEXT NOT NULL,
$_columnEmployeeEmail TEXT NOT NULL,
$_columnCheckInTime TEXT NOT NULL,
$_columnCheckOutTime TEXT,
$_columnHours INTEGER,
$_columnHourlyRate DOUBLE,
$_columnPayment DOUBLE
);''');
  }

  Future<int> addShift(
      {required String workDate,
      required String employeeName,
      required String employeeEmail,
      required String checkInTime,
      String? checkOutTime,
      int? hours,
      double? hourlyRate,
      double? payment}) async {
    final database = await DatabaseService.instance.database;
    int result = await database.insert(_tableName, {
      _columnWorkDate: workDate,
      _columnEmployeeName: employeeName,
      _columnEmployeeEmail: employeeEmail,
      _columnCheckInTime: checkInTime,
      if (checkOutTime != null) _columnCheckOutTime: checkOutTime,
      if (hours != null && hours > 0) _columnHours: hours,
      if (hourlyRate != null && hourlyRate > 0) _columnHourlyRate: hourlyRate,
      if (payment != null && payment > 0) _columnPayment: payment
    });
    // rawInsert(
    // 'INSERT INTO $tableName (work_date, employee_name, employee_email, check_in_time) VALUES (?,?,?,?)',
    // [workDate, employeeName, employeeEmail, checkInTime]);
  
    return result;
  }

  Future<List<Shift>> getAllShiftsByDate({required String workDate}) async {
    final database = await DatabaseService.instance.database;
    final shifts = await database.query(_tableName,
        where: '$_columnWorkDate = ?',
        whereArgs: [workDate],
        orderBy: _columnShiftId);

    // rawQuery(
    //     'SELECT * FROM $tableName WHERE work_date=? ORDER BY shift_id ASC',
    //     [workDate]);
    return shifts.map((shift) => Shift.fromSqfliteDatabase(shift)).toList();
  }

  Future<int> updateShift(
      {required int shiftId,
      String? employeeName,
      String? employeeEmail,
      String? checkInTime,
      String? checkOutTime,
      int? hours,
      double? hourlyRate,
      double? payment}) async {
    final database = await DatabaseService.instance.database;
    int result = await database.update(
        _tableName,
        {
          if (employeeName != null) _columnEmployeeName: employeeName,
          if (employeeEmail != null) _columnEmployeeEmail: employeeEmail,
          if (checkInTime != null) _columnCheckInTime: checkInTime,
          if (checkOutTime != null) _columnCheckOutTime: checkOutTime,
          if (hours != null && hours > 0) _columnHours: hours,
          if (hourlyRate != null && hourlyRate > 0)
            _columnHourlyRate: hourlyRate,
          if (payment != null && payment > 0) _columnPayment: payment
        },
        where: '$_columnShiftId = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [shiftId]);

    return result;
  }

  Future<int> deleteShift(int shiftId) async {
    final database = await DatabaseService.instance.database;
    int result = await database
        .delete(_tableName, where: '$_columnShiftId = ?', whereArgs: [shiftId]);
    // .rawDelete('DELETE FROM $tableName WHERE shift_id = ?', [shiftId]);
  
    return result;
  }
}
