import 'package:flutter/material.dart';
import 'package:work_time_tracker/models/shift_model.dart';
import 'package:work_time_tracker/utils/date_and_time_picker_utils.dart';
import 'package:work_time_tracker/widgets/custom_snack_bar.dart';
import '../helper/database_helper.dart';

class AddShiftController extends ChangeNotifier {

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(const Duration(hours: 1));
  final TextEditingController _noteController = TextEditingController();
  DateAndTimePickerUtils dateUtils = DateAndTimePickerUtils();

  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  TextEditingController get note => _noteController;

  pickFromDateTime({required context, required bool pickDate} ) async {
    final date = await dateUtils.pickFromDateTime(context: context, pickDate: pickDate,fromDate: fromDate) ??  _fromDate;
    if (date.isAfter(toDate)) {
          _toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
        }
    _fromDate = date;
    notifyListeners();
  }

  Future pickToDateTime({required context,required bool pickDate}) async {
    final date = await
    dateUtils.pickToDateTime(context: context, pickDate: pickDate,fromDate: fromDate,toDate: toDate) ?? _toDate;
    _toDate = date;
      notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////////////////////


  DatabaseHelper databaseHelper = DatabaseHelper();
  final List<ShiftModel> _allShiftEntries = [];


  List<ShiftModel> get allShiftEntries => _allShiftEntries;


  addShiftEntry({
    context,
    required organizationName,
    required DateTime startTime,
    DateTime? endTime,
    Duration? timeSpent,
    TextEditingController? note
  }) {
    final entry = ShiftModel(
      organizationName: organizationName,
      startTime: startTime,
      endTime: endTime,
      timeSpent: timeSpent,
      note: note?.text
    );

    if (timeSpent! < Duration(minutes: 1)) {
      CustomSnackBar.show(context, 'Starting Time is After End Time!');
      return;
    }
    saveShiftEntries(context,entry);
    notifyListeners();
  }

  void saveShiftEntries(context,entry) async {
    int result = await databaseHelper.insertShiftEntry(entry);
    if(result != 0){
      CustomSnackBar.show(context, 'successfully added');
      _noteController.clear();
      _fromDate = DateTime.now();
      _toDate = DateTime.now().add(const Duration(hours: 1));
      Navigator.of(context).pop();
    }else{
      CustomSnackBar.show(context, 'SomeThing Went Wrong');
    }
  }

  Future<void> loadAllTimeEntries(orgName) async {
    List<ShiftModel> entries = await databaseHelper.getOrganizationEntries(orgName);
    _allShiftEntries.clear();
    _allShiftEntries.addAll(entries);
    notifyListeners();
  }


}