import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/common/enums/toast_type_enum.dart';
import 'package:time_card_app/common/extensions/custom_time_format.dart';
import 'package:time_card_app/database/shifts_db.dart';
import 'package:time_card_app/model/shift.dart';

class ShiftDetailsScreen extends StatefulWidget {
  final FormAction formAction;
  final Shift shift;
  const ShiftDetailsScreen(
      {super.key, required this.formAction, required this.shift});

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  late final ShiftsDB shiftsDB;

  String title = '';
  bool isUpdateShift = false;

  final shiftDetailsFormKey = GlobalKey<FormState>();

  TimeOfDay? _selectedCheckInTime;
  TimeOfDay? _selectedCheckOutTime;

  late TextEditingController _controllerEmployeeName;
  late TextEditingController _controllerEmployeeEmail;
  late TextEditingController _controllerHourlyRate;

  @override
  void initState() {
    super.initState();

    shiftsDB = ShiftsDB();

    _controllerEmployeeName = TextEditingController();
    _controllerEmployeeEmail = TextEditingController();
    _controllerHourlyRate = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Shift currentShift = widget.shift;

    switch (widget.formAction) {
      case FormAction.addShift:
        title = 'New Time Card';
        isUpdateShift = false;
        break;
      case FormAction.updateShift:
        title = 'Time Card Details';
        isUpdateShift = true;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
            key: shiftDetailsFormKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _controllerEmployeeName,
                    decoration: const InputDecoration(
                      labelText: 'Employee Name',
                    ),
                    keyboardType: TextInputType.name,
                    maxLength: 20,
                    initialValue: null,
                    enabled: true,

                    // inputFormatters: [],
                    // validator: ,
                    // onChanged: ,
                    // onFieldSubmitted: ,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _controllerEmployeeEmail,
                    decoration: const InputDecoration(
                      labelText: 'Employee Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 40,
                    initialValue: null,
                    enabled: true,

                    // inputFormatters: [],
                    // validator: ,
                    // onChanged: ,
                    // onFieldSubmitted: ,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _controllerHourlyRate,
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      labelText: 'Hourly Rate',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    initialValue: null,
                    enabled: true,

                    // inputFormatters: [],
                    // validator: ,
                    // onChanged: ,
                    // onFieldSubmitted: ,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Check-in Time    :',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (_selectedCheckInTime != null) ...[
                        Text(
                          _selectedCheckInTime!.toStringFormat,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                      IconButton(
                        onPressed: () async {
                          final TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dial);

                          if (selectedTime != null) {
                            setState(() {
                              _selectedCheckInTime = selectedTime;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Check-out Time  :',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (_selectedCheckOutTime != null) ...[
                          Text(
                            _selectedCheckOutTime!.toStringFormat,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                        IconButton(
                          onPressed: () async {
                            final TimeOfDay? selectedTime =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.dial);

                            if (selectedTime != null) {
                              setState(() {
                                _selectedCheckOutTime = selectedTime;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.access_time,
                            color: Colors.blue,
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isUpdateShift) ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              elevation: 0,
                            ),
                            onPressed: () async {
                              int result = await shiftsDB
                                  .deleteShift(currentShift.shiftId!.toInt());
                              if (result > 0) {
                                showToastMessage(
                                    type: ToastType.success,
                                    message:
                                        "Time card has been deleted successfully");
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              "Delete",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 0,
                            ),
                            onPressed: () {
                              // shiftsDB.addShift(workDate: dateYMD,
                              // employeeName: employeeName,
                              // employeeEmail: employeeEmail,
                              // checkInTime: checkInTime
                              // )
                            },
                            child: const Text(
                              "Update",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ] else ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              elevation: 0,
                            ),
                            onPressed: () {
                              // shiftsDB.addShift(workDate: dateYMD,
                              // employeeName: employeeName,
                              // employeeEmail: employeeEmail,
                              // checkInTime: checkInTime
                              // )
                            },
                            child: const Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ]
                      ])
                ])),
      ),
    );
  }

  void showToastMessage({required ToastType type, required String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type == ToastType.error ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
