
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_time_tracker/models/shift_model.dart';

import '../models/organization_model.dart';

class DatabaseHelper{

  static DatabaseHelper? _databaseHelper;
  Database? _database;

  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  String shiftEntriesTable = 'shiftEntries';
  String colId = 'colId';
  String orgName = 'organizationName';
  String startTime = 'startTime';
  String endTime = 'endTime';
  String timeSpent = 'timeSpent';
  String note = 'note';
  String organizationTable = 'organizationTable';
  String orgId = 'orgId';
  String orgPrice = 'orgPrice';

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'shifts.db';
    var shiftDatabase  = openDatabase(path,version: 1,onCreate: _createDb);
    return shiftDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $organizationTable($orgId INTEGER PRIMARY KEY AUTOINCREMENT, $orgName TEXT UNIQUE, $orgPrice TEXT);');
    await db.execute('CREATE TABLE $shiftEntriesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $orgName TEXT, $startTime TEXT, $endTime TEXT, $timeSpent TEXT, $note TEXT, FOREIGN KEY($orgName) REFERENCES $organizationTable($orgName));');

    // await db.execute('CREATE TABLE $shiftEntriesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $startTime TEXT, $endTime TEXT, $timeSpent TEXT, $note TEXT, FOREIGN KEY($orgName) REFERENCES $organizationTable($orgName));');


    // await db.execute('CREATE TABLE $shiftEntriesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $orgName TEXT, $startTime TEXT, $endTime TEXT, $timeSpent TEXT, $note TEXT);');
  }


  // insert Operation
  Future<int> insertShiftEntry(ShiftModel shiftEntry) async{
    print(shiftEntry.note);
    Database db = await database;
    var result = db.insert(shiftEntriesTable, shiftEntry.toMap());
    return result;
  }

  // Delete operation
  // Future<int> deleteTask(int id) async {
  //   Database db = await database;
  //   var result = db.delete(timeEntriesTable,where: '$colId = ?' , whereArgs: [id]);
  //   return result;
  // }

  Future<List<ShiftModel>> getOrganizationEntries(String organizationName) async {
    Database db = await database;
    List<String> columnsToSelect = [colId, orgName, startTime, endTime, timeSpent, note];
    List<Map<String, dynamic>> map = await db.query(
      shiftEntriesTable,
      columns: columnsToSelect,
      where: '$orgName = ?',
      whereArgs: [organizationName],
    );
    int count = map.length;
    List<ShiftModel> timeEntries = [];
    for(int i =0; i < count; i++){
      timeEntries.add(ShiftModel.fromMap(map[i]));
    }
    return timeEntries;
  }

  // fetch and convert to task list
  Future<List<ShiftModel>> getShiftList() async {
    var shiftMapList = await getShiftEntriesListMap();
    int count = shiftMapList.length;
    List<ShiftModel> shiftEntries = [];
    for(int i =0; i < count; i++){
      shiftEntries.add(ShiftModel.fromMap(shiftMapList[i]));
    }
    return shiftEntries;
  }

  // fetch operation
  Future<List<Map<String,dynamic>>> getShiftEntriesListMap() async {
    Database db = await this.database;
    var result = db.query(shiftEntriesTable);
    return result;
  }

  ////////////////////////////////////////////////////////////

  Future<List<ShiftModel>> getShiftEntriesInDateRange(String organizationName, DateTime startDate, DateTime endDate) async {
    Database db = await database;
    List<Map<String, dynamic>> entries = await db.query(
      shiftEntriesTable,
      where: '$orgName = ? AND $startTime >= ? AND $endTime <= ?',
      whereArgs: [organizationName, startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return entries.map((entry) => ShiftModel.fromMap(entry)).toList();
  }

  Future<Duration> calculateTotalTimeSpent(String organizationName, DateTime startDate, DateTime endDate) async {
    List<ShiftModel> entries = await getShiftEntriesInDateRange(organizationName, startDate, endDate);
    Duration totalTimeSpent = const Duration();
    for (var entry in entries) {
      totalTimeSpent += entry.timeSpent!;
    }
    return totalTimeSpent;
  }

  ///    organization database ////////////////////////////////    organization database ///

  Future<int?> getOrganizationCount() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $organizationTable"));
    print('this is the count x $count');
    return count;
  }

  Future<int> insertOrganization(OrganizationModel orgModel) async{
    Database db = await database;
    var result = db.insert(organizationTable, orgModel.toJson());
    return result;
  }

  // Get all organizations from the database
  Future<List<OrganizationModel>> getOrganizations() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(organizationTable);

    return List.generate(maps.length, (index) {
      return OrganizationModel.fromJson(maps[index]);
    });
  }

  Future<void> deleteOrganization(String organizationName) async {
    Database db = await database;
    await db.delete(
      organizationTable,
      where: '$orgName = ?',
      whereArgs: [organizationName],
    );

    await db.delete(
      shiftEntriesTable,
      where: '$orgName = ?',
      whereArgs: [organizationName],
    );
  }
}
