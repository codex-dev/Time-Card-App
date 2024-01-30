import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/database/shifts_db.dart';
import 'package:time_card_app/model/shift.dart';
import 'package:time_card_app/presentation/widgets/shifts_list_item.dart';
import 'package:time_card_app/shared/shift_bottom_sheet.dart';

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
  int totalHours = 0;
  double laborCost = 0;

  @override
  void initState() {
    super.initState();
    shiftsDB = ShiftsDB();
    changeSelectedDate(DateTime.now());
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
        onPressed: () => ShiftBottomSheet.showShiftDetailsForm(context, FormAction.addShift),
        child: const Icon(Icons.add),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              showSelectedDateBar(context),
              const SizedBox(
                height: 30,
              ),
              showInsightsBar(context),
              const SizedBox(
                height: 20,
              ),
              showShiftsList()
            ],
          )),
    );
  }

  Row showSelectedDateBar(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            changeSelectedDate(_selectedDate.subtract(const Duration(days: 1)));
          },
        ),
        GestureDetector(
            onTap: () => selectDate(context),
            child: Text(
              dateDisplay,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          onPressed: () {
            changeSelectedDate(_selectedDate.add(const Duration(days: 1)));
          },
        ),
      ],
    );
  }

  Row showInsightsBar(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              '$totalHours\nTotal Hours',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              '\$${laborCost.toStringAsFixed(2)}\nLabor Cost',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  void changeSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    dateYMD = DateFormat('yyyy/MM/dd').format(_selectedDate);
    dateDisplay = DateFormat('E, dd MMMM yyyy').format(_selectedDate);

    loadShiftsList();
  }

  void loadShiftsList() async {
    totalHours = 0;
    laborCost = 0;

    listAllShifts = await shiftsDB.getAllShiftsByDate(workDate: dateYMD);

    for (var shiftItem in listAllShifts) {
      totalHours += shiftItem.hours ?? 0;
      laborCost += shiftItem.payment ?? 0;

      debugPrint(shiftItem.toString());
    }

    setState(() {});
  }

  Widget showShiftsList() {
    if (listAllShifts.isNotEmpty) {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Shift shiftItem = listAllShifts[index];

            return ShiftsListItem(shift: shiftItem);
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: listAllShifts.length);
    }

    return const Text(
      'No shifts found for the day.',
      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 121, 121, 121)),
    );
  }
}
