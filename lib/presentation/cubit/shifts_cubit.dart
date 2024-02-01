import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:time_card_app/common/constants/app_strings.dart';
import 'package:time_card_app/common/enums/db_operation_status_enum.dart';
import 'package:time_card_app/data/local/shifts_db.dart';
import 'package:time_card_app/model/shift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shifts_state.dart';

class ShiftsCubit extends Cubit<ShiftsState> {
  final ShiftsDB _shiftsDB = ShiftsDB();

  ShiftsCubit() : super(ShiftsState.initial());

  Future<void> getAllShiftsForTheDay({required String workDate}) async {
    emit(state.copyWith(status: ShiftsStatus.loading));

    Either<String, List<Shift>> result =
        await _shiftsDB.getAllShiftsByDate(workDate: workDate);

    result.fold(
        (error) => emit(state.copyWith(
            status: ShiftsStatus.error,
            message: AppStrings.errorLoadingShifts)), (list) {
      if (list.isNotEmpty) {
        emit(state.copyWith(status: ShiftsStatus.success, shiftsList: list));
      } else {
        emit(state.copyWith(
            status: ShiftsStatus.success,
            shiftsList: list,
            message: AppStrings.errorNoShifts));
      }
    });
  }

  Future<void> addNewShift({required Shift shift}) async {
    emit(state.copyWith(status: ShiftsStatus.loading));

    Either<String, int> result = await _shiftsDB.addShift(
        workDate: '${shift.workDate}',
        employeeName: '${shift.employeeName}',
        employeeEmail: '${shift.employeeEmail}',
        hourlyRate: shift.hourlyRate,
        checkInTime: shift.checkInTime!,
        checkOutTime: shift.checkOutTime,
        hours: shift.hours,
        payment: shift.payment);

    result.fold(
        (error) => emit(state.copyWith(
            status: ShiftsStatus.error,
            message: AppStrings.errorShiftSavingFailed)), (affectedRowCount) {
      if (affectedRowCount > 0) {
        emit(state.copyWith(
            status: ShiftsStatus.success,
            message: AppStrings.successShiftSaved));
      } else {
        emit(state.copyWith(
            status: ShiftsStatus.error, message: AppStrings.errorShiftSavingFailed));
      }
    });
  }

  Future<void> updateShift({required Shift shift}) async {
    emit(state.copyWith(status: ShiftsStatus.loading));

    Either<String, int> result = await _shiftsDB.updateShift(
        shiftId: shift.shiftId!.toInt(),
        employeeName: '${shift.employeeName}',
        employeeEmail: '${shift.employeeEmail}',
        hourlyRate: shift.hourlyRate,
        checkInTime: shift.checkInTime,
        checkOutTime: shift.checkOutTime,
        hours: shift.hours,
        payment: shift.payment);

    result.fold(
        (error) => emit(state.copyWith(
            status: ShiftsStatus.error,
            message: AppStrings.errorShiftUpdatingFailed)), (affectedRowCount) {
      if (affectedRowCount > 0) {
        emit(state.copyWith(
            status: ShiftsStatus.success,
            message: AppStrings.successShiftUpdated));
      } else {
        emit(state.copyWith(
            status: ShiftsStatus.error, message: AppStrings.errorShiftUpdatingFailed));
      }
    });
  }

  Future<void> deleteShift({required int shiftId}) async {
    emit(state.copyWith(status: ShiftsStatus.loading));

    Either<String,int> result = await _shiftsDB.deleteShift(shiftId);

    result.fold(
        (error) => emit(state.copyWith(
            status: ShiftsStatus.error,
            message: AppStrings.errorShiftDeletionFailed)), (affectedRowCount) {
      if (affectedRowCount > 0) {
        emit(state.copyWith(
            status: ShiftsStatus.success,
            message: AppStrings.successShiftDeleted));
      } else {
        emit(state.copyWith(
            status: ShiftsStatus.error, message: AppStrings.errorShiftDeletionFailed));
      }
    });

  }
}
