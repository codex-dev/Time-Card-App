import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_card_app/common/constants/app_strings.dart';
import 'package:time_card_app/common/enums/db_operation_status_enum.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/common/enums/toast_type_enum.dart';
import 'package:time_card_app/common/extensions/string_extension.dart';
import 'package:time_card_app/common/extensions/time_of_day_extension.dart';
import 'package:time_card_app/common/regex_patterns.dart';
import 'package:time_card_app/common/utils/time_utils.dart';
import 'package:time_card_app/model/shift.dart';
import 'package:time_card_app/presentation/cubit/shifts_cubit.dart';
import 'package:time_card_app/shared/toast_message.dart';

class ShiftDetailsScreen extends StatefulWidget {
  final FormAction formAction;
  final Shift shift;
  const ShiftDetailsScreen(
      {super.key, required this.formAction, required this.shift});

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  final ShiftsCubit _shiftsCubit = ShiftsCubit();

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
  }

  @override
  Widget build(BuildContext context) {
    currentShift = widget.shift;
    isUpdateShift = widget.formAction == FormAction.updateShift;

    if (currentShift.checkInTime != null) {
      _selectedCheckInTime ??= currentShift.checkInTime.toTimeOfDay;
    }

    if (currentShift.checkOutTime != null) {
      _selectedCheckOutTime ??= currentShift.checkOutTime.toTimeOfDay;
    }

    _controllerEmployeeName =
        TextEditingController(text: currentShift.employeeName);
    _controllerEmployeeEmail =
        TextEditingController(text: currentShift.employeeEmail);
    _controllerHourlyRate =
        TextEditingController(text: currentShift.hourlyRate?.toString());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdateShift
              ? AppStrings.titleTimeCardDetails
              : AppStrings.titleNewTimeCard),
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
                        hintText: "ex: John Doe",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 200, 200, 200)),
                        labelText: AppStrings.labelEmployeeName,
                      ),
                      keyboardType: TextInputType.name,
                      maxLength: 20,
                      enabled: isUpdateShift ? false : true,
                      onChanged: (value) {
                        currentShift.employeeName = value;
                      },
                      validator: (value) {
                        if (value.isNullOrEmpty) {
                          return AppStrings.errorEnterEmployeeName;
                        } else if (!RegexPatterns.regexValidPersonName
                            .hasMatch(value!)) {
                          return AppStrings.errorEnterValidName;
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
                          hintText: "ex: john@email.com",
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 200, 200, 200)),
                          labelText: AppStrings.labelEmployeeEmail,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 40,
                        enabled: isUpdateShift ? false : true,
                        onChanged: (value) {
                          currentShift.employeeEmail = value;
                        },
                        validator: (value) {
                          if (value.isNullOrEmpty) {
                            return AppStrings.errorEnterEmployeeEmail;
                          } else if (!RegexPatterns.regexValidEmail
                              .hasMatch(value!)) {
                            return AppStrings.errorEnterValidEmail;
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
                        labelText: AppStrings.labelHourlyRate,
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
                          '${AppStrings.labelCheckInTime}    :',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _selectedCheckInTime?.asString ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () async {
                            final TimeOfDay? selectedTime =
                                await showTimePicker(
                                    context: context,
                                    initialTime:
                                        _selectedCheckInTime ?? TimeOfDay.now(),
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
                            '${AppStrings.labelCheckOutTime}  :',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            _selectedCheckOutTime?.asString ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () async {
                              final TimeOfDay? selectedTime =
                                  await showTimePicker(
                                      context: context,
                                      initialTime: _selectedCheckOutTime ??
                                          TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.dial);

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
                    BlocConsumer<ShiftsCubit, ShiftsState>(
                      bloc: _shiftsCubit,
                      builder: (context, state) {
                        if (state.status == ShiftsStatus.loading) {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          );
                        } else if (state.status == ShiftsStatus.error) {
                          AppToast.showMessage(
                              type: ToastType.error, message: state.message!);
                        } else if (state.status == ShiftsStatus.success) {
                          AppToast.showMessage(
                              type: ToastType.success, message: state.message!);
                        }
                        return const SizedBox.shrink();
                      },
                      listener: (context, state) {
                        if (state.status == ShiftsStatus.success) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
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
                              onPressed: () {
                                _shiftsCubit.deleteShift(
                                    shiftId: currentShift.shiftId!.toInt());
                              },
                              child: const Text(
                                AppStrings.btnDelete,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 0,
                              ),
                              onPressed: () {
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
                                        _selectedCheckInTime?.asString
                                    ..checkOutTime =
                                        _selectedCheckOutTime?.asString
                                    ..hours = TimeUtils.getDurationInHours(
                                        inTime: _selectedCheckInTime,
                                        outTime: _selectedCheckOutTime)
                                    ..payment = calculatePayment();

                                  _shiftsCubit.updateShift(shift: currentShift);
                                }
                              },
                              child: const Text(
                                AppStrings.btnUpdate,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ] else ...[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (_shiftDetailsFormKey.currentState!
                                        .validate() &&
                                    validateTime()) {
                                  currentShift
                                    ..workDate = currentShift.workDate
                                    ..employeeName =
                                        _controllerEmployeeName.text
                                    ..employeeEmail =
                                        _controllerEmployeeEmail.text
                                    ..hourlyRate = double.tryParse(
                                        _controllerHourlyRate.text)
                                    ..checkInTime =
                                        _selectedCheckInTime?.asString
                                    ..checkOutTime =
                                        _selectedCheckOutTime?.asString
                                    ..hours = TimeUtils.getDurationInHours(
                                        inTime: _selectedCheckInTime,
                                        outTime: _selectedCheckOutTime)
                                    ..payment = calculatePayment();

                                  _shiftsCubit.addNewShift(shift: currentShift);
                                }
                              },
                              child: const Text(
                                AppStrings.btnSave,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ]
                        ])
                  ])),
        ),
      ),
    );
  }

  bool validateTime() {
    if (_selectedCheckInTime == null) {
      AppToast.showMessage(
          type: ToastType.error, message: AppStrings.errorSetCheckInTime);
      return false;
    }

    if (_selectedCheckOutTime != null &&
        _selectedCheckOutTime!.compareTo(_selectedCheckInTime!) <= 0) {
      AppToast.showMessage(
          type: ToastType.error, message: AppStrings.errorEarlyCheckOutTime);
      return false;
    }

    return true;
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
