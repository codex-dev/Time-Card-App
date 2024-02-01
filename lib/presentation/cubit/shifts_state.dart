part of 'shifts_cubit.dart';

class ShiftsState extends Equatable {
  final ShiftsStatus status;
  final List<Shift>? shiftsList;
  final String? message;

  ShiftsState(
      {required this.status, this.shiftsList,  this.message}) {
    debugPrint('Shifts - shiftsList:${shiftsList?.length}');
  }

  static ShiftsState initial() => ShiftsState(
      status: ShiftsStatus.initial,
      shiftsList:  const [],
      message: null);

  ShiftsState copyWith(
          {ShiftsStatus? status,
          List<Shift>? shiftsList,
          String? message}) =>
      ShiftsState(
        status: status ?? this.status,
        shiftsList: shiftsList ?? this.shiftsList,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [status, shiftsList, message];
}
