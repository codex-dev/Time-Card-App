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
  late DateTime _selectedDate;
  late String dateYMD;
  late String dateDisplay;
  late final ShiftsDB shiftsDB;
  List<Shift> listAllShifts = [];

  @override
  void initState() {
    super.initState();
    shiftsDB = ShiftsDB();
    changeSelectedDate(DateTime.now());

    // testDbOperations();
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDate) {
      changeSelectedDate(picked);
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
          showShiftDetailsForm(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      changeSelectedDate(
                          _selectedDate.subtract(const Duration(days: 1)));
                    },
                  ),
                  GestureDetector(
                      onTap: () => selectDate(context),
                      child: Text(
                        dateDisplay,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () {
                      changeSelectedDate(
                          _selectedDate.add(const Duration(days: 1)));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (listAllShifts.isNotEmpty) ...[
                ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Shift shiftItem = listAllShifts[index];

                      return displayShiftItem(shiftItem, context);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: listAllShifts.length)
              ] else ...[
                const Text(
                  'No shifts found for the day.',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 121, 121, 121)),
                )
              ]
            ],
          )),
    );
  }

  Container displayShiftItem(Shift shiftItem, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 221, 221),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shiftItem.employeeName,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                shiftItem.employeeEmail,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              )
            ],
          ),
          Text(
            '${shiftItem.checkInTime} - ${(shiftItem.checkOutTime == null || shiftItem.checkOutTime!.isEmpty) ? 'now' : shiftItem.checkOutTime}',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.edit_note_outlined),
            onPressed: () => showShiftDetailsForm(context),
          )
        ],
      ),
    );
  }

  void changeSelectedDate(DateTime newDate) async {
    _selectedDate = newDate;
    dateYMD = DateFormat('yyyy/MM/dd').format(_selectedDate);
    dateDisplay = DateFormat('E, dd MMMM yyyy').format(_selectedDate);

    listAllShifts = await shiftsDB.getAllShiftsByDate(workDate: dateYMD);

    setState(() {});
  }

  Future<void> showShiftDetailsForm(BuildContext context) {
    return showModalBottomSheet(
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
