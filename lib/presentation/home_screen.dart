import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_card_app/database/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  late String dateYMD = DateFormat("yyyy/MM/dd").format(_selectedDate);
  late DailyRecord dailyRecord = DailyRecord(dateYMD, 0, 0.0, []);

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

  double _calculateTotalWorkHours() {
    double totalHours = 0;
    for (var shift in dailyRecord.shiftsList) {
      totalHours +=
          shift.checkOutTime.difference(shift.checkInTime).inHours.toDouble();
    }
    return totalHours;
  }
}
