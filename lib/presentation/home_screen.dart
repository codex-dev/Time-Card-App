import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_card_app/database/database_service.dart';
import 'package:time_card_app/database/shifts_db.dart';
import 'package:time_card_app/model/shift.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  late String dateYMD;
  late final ShiftsDB shiftsDB;
  late List<Shift> listAllShifts;

  // late DailyRecord dailyRecord = DailyRecord(dateYMD, 0, 0.0, []);

  @override
  void initState() {
    super.initState();
    shiftsDB = ShiftsDB();
    dateYMD = DateFormat("yyyy/MM/dd").format(_selectedDate);

    testDbOperations();
  }

  Future<void> testDbOperations() async {
    shiftsDB.deleteShift(1);
    
    listAllShifts = await shiftsDB.getAllShiftsByDate(workDate: dateYMD);
    debugPrint(
        '// Found ${listAllShifts.length} shift${listAllShifts.length > 1 ? 's' : ''} in $dateYMD');


    // shiftsDB.addShift(
    //     workDate: dateYMD,
    //     employeeName: 'Sahan',
    //     employeeEmail: 'sahan@ft.lk',
    //     checkInTime: '09:15');

    // listAllShifts = await shiftsDB.getAllShiftsByDate(workDate: dateYMD);
    // debugPrint(
    //     '// Found ${listAllShifts.length} shift${listAllShifts.length > 1 ? 's' : ''} in $dateYMD');

    // shiftsDB.updateShift(
    //     shiftId: 2,
    //     checkInTime: '10:00',
    //     checkOutTime: '18:00',
    //     hourlyRate: 23.5,
    //     hours: 8,
    //     payment: 8 * 23.5);
    // listAllShifts = await shiftsDB.getAllShiftsByDate(workDate: dateYMD);
    // debugPrint(
    //     '// Found ${listAllShifts.length} shift${listAllShifts.length > 1 ? 's' : ''} in $dateYMD');

    for (var sh in listAllShifts) {
      debugPrint(sh.toString());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Cards"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: ElevatedButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () => _selectDate(context), child: Text(dateYMD))
            ],
          )),
    );
  }

  addPrefix(int value) => value < 10 ? "0$value" : value;

  // double _calculateTotalWorkHours() {
  //   double totalHours = 0;
  //   for (var shift in dailyRecord.shiftsList) {
  //     totalHours +=
  //         shift.checkOutTime.difference(shift.checkInTime).inHours.toDouble();
  //   }
  //   return totalHours;
  // }
}
