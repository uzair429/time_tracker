import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../helper/shared_pref_helper.dart';
import '../models/shift_model.dart';
import '../utils/date_and_time_picker_utils.dart';
import '../widgets/custom_snack_bar.dart';

class StartShiftController extends ChangeNotifier {

  DateAndTimePickerUtils dateUtils = DateAndTimePickerUtils();
  DateTime _startDate = DateTime.now();
  bool _isShiftRunning = false;
  Duration _totalBreakDuration = Duration();

  final TextEditingController _startShiftNoteController = TextEditingController();
  final TextEditingController _breakController = TextEditingController();

  DateTime get startDate =>  _startDate;
  bool get isShiftRunning => _isShiftRunning;
  TextEditingController get startShiftNoteController => _startShiftNoteController;
  TextEditingController get breakController => _breakController;
  Duration get totalBreakDuration => _totalBreakDuration;

  pickStartDateTime({required context, required bool pickDate} ) async {
    final date = await dateUtils.pickFromDateTime
      (context: context, pickDate: pickDate,fromDate: startDate) ??  _startDate;
    _startDate = date;
    SharedPrefHelper.saveStartDate(date);
    isShiftRun();
    notifyListeners();
  }

  Future startShift() async {
    await SharedPrefHelper.saveStartDate(_startDate);
    isShiftRun();
    notifyListeners();
  }

  Future isShiftRun() async {
     DateTime? date =  await SharedPrefHelper.getStartDate();
     print('date is available $date');
     date == null? _isShiftRunning = false: _isShiftRunning = true;
     if (date != null) {
       _startDate = date;
     }
     notifyListeners();
     }

     disposeShift() async {
       await SharedPrefHelper.deleteStartDate();
       await SharedPrefHelper.deleteTotalBreak();
       isShiftRun();
       _startDate = DateTime.now();
       _totalBreakDuration = const Duration();
       notifyListeners();
     }


   addBreak() async {
     String breakTime = _breakController.text;
     if (breakTime.isNotEmpty) {
       int minutes = int.tryParse(breakTime) ?? 0;
         _totalBreakDuration += Duration(minutes: minutes);
         await SharedPrefHelper.saveTotalBreak(_totalBreakDuration);
     }
     _breakController.clear();
     notifyListeners();
     getTotalBreak();
   }

   getTotalBreak() async {
     Duration? totalDuration = await SharedPrefHelper.getTotalBreak();
     if(totalDuration != null){
       _totalBreakDuration = totalDuration;
     }
     notifyListeners();
   }

  DatabaseHelper databaseHelper = DatabaseHelper();

  addShiftEntry2({
    context,
    required organizationName,
    required DateTime startTime,
    DateTime? endTime,
    Duration? timeSpent,
    TextEditingController? note
  }) {
    print('satart of the add');
    final entry = ShiftModel(
        organizationName: organizationName,
        startTime: startTime,
        endTime: endTime,
        timeSpent: timeSpent,
        note: note?.text
    );
    print(timeSpent!);
    if (timeSpent! < Duration(minutes: 1)) {
      CustomSnackBar.show(context, 'Starting Time is After End Time!');
      return;
    }
    saveShiftEntries2(context,entry);
    notifyListeners();
  }

  void saveShiftEntries2(context,entry) async {
    print('this is the start time juat before adding ${entry.startTime}');
    print('this is the end time juat before adding ${entry.endTime}');
    int result = await databaseHelper.insertShiftEntry(entry);
    if(result != 0){
      CustomSnackBar.show(context, 'successfully added');
      _startShiftNoteController.clear();
      _startDate = DateTime.now();
      disposeShift();
      Navigator.of(context).pop();
    }else{
      CustomSnackBar.show(context, 'SomeThing Went Wrong');
    }
  }


}
