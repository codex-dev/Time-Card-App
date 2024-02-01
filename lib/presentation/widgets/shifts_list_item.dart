import 'package:flutter/material.dart';
import 'package:time_card_app/common/constants/app_strings.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/common/extensions/string_extension.dart';
import 'package:time_card_app/model/shift.dart';
import 'package:time_card_app/presentation/screens/shift_details_screen.dart';

class ShiftsListItem extends StatelessWidget {
  final Shift shift;
  const ShiftsListItem({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 225, 225),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.employeeName ?? '',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        shift.employeeEmail ?? '',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              IconButton(
                  icon: const Icon(Icons.edit_note_outlined),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShiftDetailsScreen(
                                formAction: FormAction.updateShift,
                                shift: shift)));
                  })
            ],
          ),
          const Divider(color: Colors.black,
          thickness: 1,
          height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  const Text(AppStrings.labelCheckIn),
                  Text(
                    '${shift.checkInTime}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(AppStrings.labelCheckOut),
                  Text(
                    '${shift.checkOutTime.isNullOrEmpty ? '-' : shift.checkOutTime}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
