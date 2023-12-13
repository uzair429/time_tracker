import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefHelper {
  static const String _startDate = 'startDate';
  static const String _totalBreak = 'totalBreak';

  static Future<bool> saveStartDate(DateTime date) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dateString = date.toIso8601String();
    return await preferences.setString(_startDate , dateString);
  }

  static Future<DateTime?> getStartDate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? dateString = preferences.getString(_startDate);
    if(dateString == null){
      return null;
    }
    return DateTime.parse(dateString);
  }

  static Future deleteStartDate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(';delete is called');
    var x = await preferences.remove(_startDate);
    print(x);
  }

 /// total break ////////////////////////////////// total break ///


  static Future<bool> saveTotalBreak(Duration totalBreak) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int totalBreakMilliseconds = totalBreak.inMilliseconds;
    return await preferences.setInt(_totalBreak, totalBreakMilliseconds);
  }

  static Future<Duration?> getTotalBreak() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int totalBreakMilliseconds = preferences.getInt(_totalBreak) ?? 0;
    return Duration(milliseconds: totalBreakMilliseconds);
  }

  static Future deleteTotalBreak() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('delete is called');
    var x = await preferences.remove(_totalBreak);
    print(x);
  }

}