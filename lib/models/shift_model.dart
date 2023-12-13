class ShiftModel {
  String? organizationName;
  DateTime startTime;
  DateTime? endTime;
  Duration? timeSpent;
  String? note;

  ShiftModel({
    this.organizationName,
    required this.startTime,
    this.endTime,
    this.timeSpent,
    this.note,
  });

  // Convert TaskModel to a map
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'timeSpent': timeSpent?.inSeconds,
      'note': note,
      'organizationName': organizationName,
    };
  }

  // Create a TaskModel from a map
  factory ShiftModel.fromMap(Map<String, dynamic> map) {
    print(map['note']);
    return ShiftModel(
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      timeSpent: Duration(seconds: int.parse(map['timeSpent'])),
      note: map['note'],
      organizationName: map['organizationName'],
    );
  }
}