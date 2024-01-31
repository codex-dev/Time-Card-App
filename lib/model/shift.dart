class Shift {
  int? shiftId;
  String? workDate;
  String? employeeName;
  String? employeeEmail;
  String? checkInTime;
  String? checkOutTime;
  int? hours;
  double? hourlyRate;
  double? payment;

  Shift(
      {this.workDate,
      this.employeeName,
      this.employeeEmail,
      this.checkInTime,
      this.shiftId,
      this.checkOutTime,
      this.hours,
      this.hourlyRate,
      this.payment});

  factory Shift.fromSqfliteDatabase(Map<String, dynamic> map) => Shift(
      shiftId: map['shift_id']?.toInt() ?? 0,
      workDate: map['work_date'] ?? '',
      employeeName: map['employee_name'] ?? '',
      employeeEmail: map['employee_email'] ?? '',
      checkInTime: map['check_in_time'] ?? '',
      checkOutTime: map['check_out_time'] ?? '',
      hours: map['hours']?.toInt() ?? 0,
      hourlyRate: map['hourly_rate']?.toDouble() ?? 0,
      payment: map['payment']?.toDouble() ?? 0);

      @override
  String toString() {
    return '''
    {
      shift_id : $shiftId,
      work_date : $workDate,
      employee_name : $employeeName,
      emplyee_email : $employeeEmail,
      check_in_time : $checkInTime,
      check_out_time : $checkOutTime,
      hours : $hours,
      hourly_rate : $hourlyRate,
      payment : $payment
    }
    ''';
  }
}
