import 'package:flutter/material.dart';
import 'package:time_card_app/common/enums/form_action_enum.dart';
import 'package:time_card_app/model/shift.dart';
import 'package:time_card_app/shared/shift_bottom_sheet.dart';

class ShiftsListItem extends StatelessWidget {
  final Shift shift;
  const ShiftsListItem({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
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
                shift.employeeName,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                shift.employeeEmail,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              )
            ],
          ),
          Text(
            '${shift.checkInTime} - ${(shift.checkOutTime == null || shift.checkOutTime!.isEmpty) ? 'now' : shift.checkOutTime}',
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.edit_note_outlined),
            onPressed: () =>
                ShiftBottomSheet.showShiftDetailsForm(context, FormAction.updateShift),
          )
        ],
      ),
    );
  }

}