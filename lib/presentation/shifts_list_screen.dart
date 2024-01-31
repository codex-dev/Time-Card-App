import 'package:flutter/material.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/common/formatters/date_time_formatter.dart';
import 'package:time_card_app/database/shifts_db.dart';
import 'package:time_card_app/model/shift.dart';
import 'package:time_card_app/presentation/shift_details_screen.dart';
import 'package:time_card_app/presentation/widgets/shifts_list_item.dart';

class ShiftsListScreen extends StatefulWidget {
  const ShiftsListScreen({super.key});

  @override
  State<ShiftsListScreen> createState() => _ShiftsListScreenState();
}

class _ShiftsListScreenState extends State<ShiftsListScreen> {
  late final ShiftsDB shiftsDB;

  late DateTime _selectedDate;
  late String dateYMD;
  late String dateDisplay;

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
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShiftDetailsScreen(
                        formAction: FormAction.addShift,
                        shift: Shift(workDate: dateYMD))))
            .then((value) => loadShiftsList()),
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
                color: const Color.fromARGB(255, 168, 177, 226),
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
                color: const Color.fromARGB(255, 168, 177, 226),
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

    dateYMD = DateTimeFormatter.formatDateToString(
        dateFormat: 'yyyy/MM/dd', date: _selectedDate);
    dateDisplay = DateTimeFormatter.formatDateToString(
        dateFormat: 'E, dd MMMM yyyy', date: _selectedDate);

    loadShiftsList();
  }

  Future<void> loadShiftsList() async {
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

  refreshList() async {
    //NOTE: this doesn't work atm
    await loadShiftsList();
  }

  Widget showShiftsList() {
    if (listAllShifts.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () => loadShiftsList(),
        child: ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Shift shiftItem = listAllShifts[index];

              return ShiftsListItem(
                  shift: shiftItem, funcRefreshList: refreshList);
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
            itemCount: listAllShifts.length),
      );
    }

    return const Text(
      'No shifts found for the day.',
      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 121, 121, 121)),
    );
  }
}
