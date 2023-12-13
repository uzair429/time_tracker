import 'package:flutter/material.dart';

class DateAndTimePickerUtils{

  Future<DateTime?> pickFromDateTime({required context, required bool pickDate, required fromDate}) async {
    final date = await pickDateTime(context, fromDate, pickDate: pickDate);
    if (date == null) return null;
    return date;
  }

  Future<DateTime?> pickToDateTime({required context, required bool pickDate, required toDate,required fromDate}) async {
    final date = await pickDateTime(context, toDate, pickDate: pickDate, firstDate: pickDate ? fromDate : null);
    if (date == null) return null;
    return date;
    // _toDate = date;
    // notifyListeners();
  }

  Future<DateTime?> pickDateTime(BuildContext context , DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;

      final time =
      Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;

      final date =
      DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
}