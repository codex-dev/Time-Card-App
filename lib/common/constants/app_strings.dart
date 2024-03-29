class AppStrings{

  static const String titleTimeCards = 'Time Cards';
  static const String titleTimeCardDetails = 'Time Card Details';
  static const String titleNewTimeCard= 'New Time Card';
  
  static const String labelTotalHours = 'Total Hours';
  static const String labelLaborCost = 'Labor Cost';
  static const String labelEmployeeName = 'Employee Name';
  static const String labelEmployeeEmail = 'Employee Email';
  static const String labelHourlyRate = 'Hourly Rate';
  static const String labelCheckInTime = 'Check-in Time';
  static const String labelCheckOutTime = 'Check-out Time';
  static const String labelCheckIn = 'Check In';
  static const String labelCheckOut = 'Check Out';

  static const String btnDelete = 'Delete';
  static const String btnUpdate = 'Update';
  static const String btnSave = 'Save';

  static const String errorEnterEmployeeName = 'Please enter employee name';
  static const String errorEnterValidName = 'Please enter a valid name (First Name & Last Name)';
  static const String errorEnterEmployeeEmail='Please enter employee email';
  static const String errorEnterValidEmail = 'Please enter a valid email';
  
  // toasts
  static const String errorSetCheckInTime = 'Please set check-in time';
  static const String errorEarlyCheckOutTime = 'Check-out time can\'t be earlier than check-in time';
  static const String errorLoadingShifts = 'Error occured while loading the Time Cards';
  static const String errorNoShifts = 'No Time Cards found for the day';
  static const String errorShiftSavingFailed = 'Time Card saving failed';
  static const String errorShiftUpdatingFailed = 'Time Card updating failed';
  static const String errorShiftDeletionFailed = 'Time Card deletion failed';

  static const String successShiftSaved = 'Time Card has been saved successfully';
  static const String successShiftUpdated = 'Time Card has been updated successfully';
  static const String successShiftDeleted = 'Time Card has been deleted successfully';
}