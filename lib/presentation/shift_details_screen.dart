import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/common/enums/toast_type_enum.dart';
import 'package:time_card_app/common/extensions/time_of_day_extension.dart';
import 'package:time_card_app/common/regex_patterns.dart';
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

  bool isUpdateShift = false;
  late Shift currentShift;

  final _shiftDetailsFormKey = GlobalKey<FormState>();

  TimeOfDay? _selectedCheckInTime;
  TimeOfDay? _selectedCheckOutTime;

  late TextEditingController _controllerEmployeeName;
  late TextEditingController _controllerEmployeeEmail;
  late TextEditingController _controllerHourlyRate;

  @override
  void initState() {
    super.initState();

    shiftsDB = ShiftsDB();
  }

  @override
  Widget build(BuildContext context) {
    currentShift = widget.shift;
    isUpdateShift = widget.formAction == FormAction.updateShift;

    _controllerEmployeeName =
        TextEditingController(text: currentShift.employeeName);
    _controllerEmployeeEmail =
        TextEditingController(text: currentShift.employeeEmail);
    _controllerHourlyRate =
        TextEditingController(text: currentShift.hourlyRate?.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdateShift ? 'Time Card Details' : 'New Time Card'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
            key: _shiftDetailsFormKey,
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
                    enabled: isUpdateShift ? false : true,
                    onChanged: (value) {
                      currentShift.employeeName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter employee name";
                      } else if (!RegexPatterns.regexValidPersonName
                          .hasMatch(value)) {
                        return "Please enter a valid name";
                      }
                      return null;
                    },
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
                      enabled: isUpdateShift ? false : true,
                      onChanged: (value) {
                        currentShift.employeeEmail = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter employee email";
                        } else if (!RegexPatterns.regexValidEmail
                            .hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      }),
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
                    enabled: true,
                    onChanged: (value) {
                      currentShift.hourlyRate = double.tryParse(value);
                    },
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
                      Text(
                        _selectedCheckInTime?.asString ??
                            (isUpdateShift
                                ? currentShift.checkInTime ?? ''
                                : ''),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
                        Text(
                          _selectedCheckOutTime?.asString ??
                              (isUpdateShift
                                  ? currentShift.checkOutTime ?? ''
                                  : ''),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
                              } else {
                                showToastMessage(
                                    type: ToastType.error,
                                    message: "Time card deletion failed");
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
                            onPressed: () async {
                              if (_shiftDetailsFormKey.currentState!
                                      .validate() &&
                                  validateTime()) {
                                currentShift
                                  ..workDate = currentShift.workDate
                                  ..employeeName = currentShift.employeeName
                                  ..employeeEmail = currentShift.employeeEmail
                                  ..hourlyRate = double.tryParse(
                                      _controllerHourlyRate.text)
                                  ..checkInTime =
                                      _selectedCheckInTime?.asString ??
                                          currentShift.checkInTime
                                  ..checkOutTime =
                                      _selectedCheckOutTime?.asString ??
                                          currentShift.checkOutTime
                                  ..hours = getDurationInHours(
                                      inTime: _selectedCheckInTime,
                                      outTime: _selectedCheckOutTime)
                                  ..payment = calculatePayment();

                                int result = await shiftsDB.updateShift(
                                    shiftId: currentShift.shiftId!.toInt(),
                                    employeeName:
                                        '${currentShift.employeeName}',
                                    employeeEmail:
                                        '${currentShift.employeeEmail}',
                                    hourlyRate: currentShift.hourlyRate,
                                    checkInTime: currentShift.checkInTime,
                                    checkOutTime: currentShift.checkOutTime,
                                    hours: currentShift.hours,
                                    payment: currentShift.payment);

                                if (result > 0) {
                                  showToastMessage(
                                      type: ToastType.success,
                                      message:
                                          'Time card has been updated successfully');
                                  Navigator.pop(context);
                                } else {
                                  showToastMessage(
                                      type: ToastType.error,
                                      message: 'Time card updating failed');
                                }
                              }
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
                            onPressed: () async {
                              if (_shiftDetailsFormKey.currentState!
                                      .validate() &&
                                  validateTime()) {
                                currentShift
                                  ..workDate = currentShift.workDate
                                  ..employeeName = _controllerEmployeeName.text
                                  ..employeeEmail =
                                      _controllerEmployeeEmail.text
                                  ..hourlyRate = double.tryParse(
                                      _controllerHourlyRate.text)
                                  ..checkInTime = _selectedCheckInTime?.asString
                                  ..checkOutTime =
                                      _selectedCheckOutTime?.asString
                                  ..hours = getDurationInHours(
                                      inTime: _selectedCheckInTime,
                                      outTime: _selectedCheckOutTime)
                                  ..payment = calculatePayment();

                                int result = await shiftsDB.addShift(
                                    workDate: '${currentShift.workDate}',
                                    employeeName:
                                        '${currentShift.employeeName}',
                                    employeeEmail:
                                        '${currentShift.employeeEmail}',
                                    hourlyRate: currentShift.hourlyRate,
                                    checkInTime: currentShift.checkInTime!,
                                    checkOutTime: currentShift.checkOutTime,
                                    hours: currentShift.hours,
                                    payment: currentShift.payment);

                                if (result > 0) {
                                  showToastMessage(
                                      type: ToastType.success,
                                      message:
                                          'Time card has been saved successfully');
                                  Navigator.pop(context);
                                } else {
                                  showToastMessage(
                                      type: ToastType.error,
                                      message: 'Time card saving failed');
                                }
                              }
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

  bool validateTime() {
    // either previously set check-in time or selectedcheckintime shouldn't be null; both cant be null at the same time
    if (currentShift.checkInTime == null && _selectedCheckInTime == null) {
      showToastMessage(
          type: ToastType.error, message: "Please set check-in time");
      return false;
    }

    //in case user just selected checkout time when editing a shift, at that time _selectedCheckInTime is null.
    // so below is only applied when user updates shift details whithout changing check-in time.
    // then only we have to do below.
    if (currentShift.checkInTime != null) {
      String checkInHour = currentShift.checkInTime!.split(":")[0];
      String checkInMinute = currentShift.checkInTime!.split(":")[1];
      _selectedCheckInTime ??= TimeOfDay(
          hour: int.tryParse(checkInHour) ?? 23,
          minute: int.tryParse(checkInMinute) ?? 59);
    }

    if (_selectedCheckOutTime != null &&
        _selectedCheckOutTime!.compareTo(_selectedCheckInTime!) <= 0) {
      showToastMessage(
          type: ToastType.error,
          message: "Check-out time can't be earlier than check-in time");
      return false;
    }

    return true;
  }

  int? getDurationInHours({TimeOfDay? inTime, TimeOfDay? outTime}) {
    if (inTime == null || outTime == null) return null;

    double doubleInTime =
        inTime.hour.toDouble() + (inTime.minute.toDouble() / 60);
    double doubleOutTime =
        outTime.hour.toDouble() + (outTime.minute.toDouble() / 60);

    double timeDiff = doubleOutTime - doubleInTime;

    int hr = timeDiff.truncate();

    return hr > 0 ? hr : null;
  }

  double? calculatePayment() {
    if (currentShift.hours == null || currentShift.hourlyRate == null) {
      return null;
    }

    return (currentShift.hours! * currentShift.hourlyRate!);
  }

  @override
  void dispose() {
    _controllerEmployeeName.dispose();
    _controllerEmployeeEmail.dispose();
    _controllerHourlyRate.dispose();
    super.dispose();
  }
}
