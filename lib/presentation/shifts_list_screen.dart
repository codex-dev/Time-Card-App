import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_card_app/common/enums/db_operation_status_enum.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/common/extensions/string_extension.dart';
import 'package:time_card_app/common/formatters/date_time_formatter.dart';
import 'package:time_card_app/cubit/shifts_cubit.dart';
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
  final ShiftsCubit _shiftsCubit = ShiftsCubit();

  late DateTime _selectedDate;
  late String dateYMD;
  late String dateDisplay;

  @override
  void initState() {
    super.initState();

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

  void changeSelectedDate(DateTime newDate) {
    _selectedDate = newDate;

    dateYMD = DateTimeFormatter.formatDateToString(
        dateFormat: 'yyyy/MM/dd', date: _selectedDate);
    dateDisplay = DateTimeFormatter.formatDateToString(
        dateFormat: 'E, dd MMMM yyyy', date: _selectedDate);

    setState(() {});

    _shiftsCubit.getAllShiftsForTheDay(workDate: dateYMD);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        shift: Shift(workDate: dateYMD)))).then((value) =>
                _shiftsCubit.getAllShiftsForTheDay(workDate: dateYMD)),
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding: const EdgeInsets.all(15),
                  child: showSelectedDateBar(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  BlocBuilder<ShiftsCubit, ShiftsState>(
                    bloc: _shiftsCubit,
                    builder: (context, state) {
                      if (state.status == ShiftsStatus.loading) {
                        return showShiftsInformation(
                          totalHours: 0,
                          laborCost: 0,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      } else if (state.status == ShiftsStatus.error) {
                        return showShiftsInformation(
                            totalHours: 0,
                            laborCost: 0,
                            child: Text(
                              '${state.message}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 121, 121, 121)),
                            ));
                      } else if (state.status == ShiftsStatus.success) {
                        List<Shift>? listAllShifts = state.shiftsList;
                        int totalHours = 0;
                        double laborCost = 0;

                        if (listAllShifts != null && listAllShifts.isNotEmpty) {
                          for (var shiftItem in listAllShifts) {
                            totalHours += shiftItem.hours ?? 0;
                            laborCost += shiftItem.payment ?? 0;

                            debugPrint(shiftItem.toString());
                          }

                          return showShiftsInformation(
                              totalHours: totalHours,
                              laborCost: laborCost,
                              child: RefreshIndicator(
                                  onRefresh: () => _shiftsCubit
                                      .getAllShiftsForTheDay(workDate: dateYMD),
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Shift shiftItem = listAllShifts[index];

                                      return ShiftsListItem(shift: shiftItem);
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: listAllShifts.length,
                                  )));
                        }

                        if (!state.message.isNullOrEmpty) {
                          return showShiftsInformation(
                              totalHours: totalHours,
                              laborCost: laborCost,
                              child: Text(
                                '${state.message}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 121, 121, 121)),
                              ));
                        }
                      }
                      return showShiftsInformation(totalHours: 0, laborCost: 0);
                    },
                  )
                ])),
              ),
            ],
          )),
    );
  }

  Row showSelectedDateBar() {
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

  Widget showShiftsInformation(
      {required int totalHours, required double laborCost, Widget? child}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showInsightsBar(totalHours: totalHours, laborCost: laborCost),
        const SizedBox(
          height: 15,
        ),
        if (child != null) ...[child]
      ],
    );
  }

  Row showInsightsBar({required int totalHours, required double laborCost}) {
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
}
