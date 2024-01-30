import 'package:flutter/material.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';

class ShiftBottomSheet {
  static showShiftDetailsForm(BuildContext context, FormAction formAction) {
    final String title;
    final bool isUpdateShift;
    final shiftDetailsFormKey = GlobalKey<FormState>();

    switch (formAction) {
      case FormAction.addShift:
        title = 'New Shift';
        isUpdateShift = false;
        break;
      case FormAction.updateShift:
        title = 'Shift Details';
        isUpdateShift = true;
        break;
    }

    return showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              width: MediaQuery.sizeOf(context).width,
              child: Form(
                  key: shiftDetailsFormKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                              iconSize: 30,
                              color: const Color.fromARGB(255, 125, 125, 125),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          // controller: ,
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
                          // controller: ,
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
                          // controller: ,
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
                        TextFormField(
                          // controller: ,
                          decoration: const InputDecoration(
                            labelText: 'Check-in Time',
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 8,
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
                          // controller: ,
                          decoration: const InputDecoration(
                            labelText: 'Check-out Time',
                          ),
                          keyboardType: TextInputType.text,
                          maxLength: 8,
                          initialValue: null,
                          enabled: true,

                          // inputFormatters: [],
                          // validator: ,
                          // onChanged: ,
                          // onFieldSubmitted: ,
                        ),
                        const SizedBox(
                          height: 15,
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
                                  onPressed: () {},
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
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
                                    style: TextStyle(color: Colors.white),
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ]
                            ])
                      ])),
            ),
          );
        });
  }
}
