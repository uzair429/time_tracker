import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/controller/organization_controller.dart';
import '../models/shift_model.dart';

class ShiftDataSource extends DataGridSource {

  ShiftDataSource({required List<ShiftModel> shiftData,context}) {
    OrganizationController orgController = Provider.of<OrganizationController>(context, listen: false);
    _shiftData = shiftData.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<List<DateTime>>(columnName: 'date', value: [e.startTime, e.endTime!]),
      DataGridCell<Duration>(columnName: 'hours', value: e.timeSpent),
      DataGridCell<String>(columnName: 'note', value: e.note),
      DataGridCell<String>(columnName: 'wages', value: '${OrganizationController()
          .calculateTotalWages(e.timeSpent!, orgController.selectedOrganizationPrice!)}\$'),
    ])).toList();
  }

  List<DataGridRow> _shiftData = [];

  @override
  List<DataGridRow> get rows => _shiftData;

  @override
  String calculateSummaryValue(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      ) {

    // print(summaryColumn?.name);
    // if (summaryColumn?.name == 'wages') {
    //   print('4444444444444444444444');
    //   double totalWages = 0.0;
    //   for (final DataGridRow row in rows) {
    //     final DataGridCell? cell = row.getCells().firstWhereOrNull(
    //           (DataGridCell element) => element.columnName == 'wages',
    //     );
    //     if (cell != null && cell.value != null) {
    //       totalWages += double.tryParse(cell.value.toString()) ?? 0.0;
    //     }
    //   }
    //   print('4444444444444444444444 $totalWages');
    //   return totalWages.toStringAsFixed(2); // Format as needed
    // }

    List<Duration> getCellValues(GridSummaryColumn summaryColumn) {
      final List<Duration> values = <Duration>[];
      for (final DataGridRow row in rows) {
        final DataGridCell? cell = row.getCells().firstWhereOrNull(
              (DataGridCell element) => element.columnName == summaryColumn.columnName,
        );
        if (cell != null && cell.value != null) {
          values.add(cell.value);
        }
      }
      return values;
    }

    String? title = summaryRow.title;
    print(title);
    String? result;
    if (title != null) {
      print(title);
      if (summaryRow.showSummaryInRow && summaryRow.columns.isNotEmpty) {
        for (final GridSummaryColumn summaryColumn in summaryRow.columns) {
          if (title!.contains(summaryColumn.name)) {
            Duration totalDuration = Duration();
            final List<Duration> values = getCellValues(summaryColumn);
            if (values.isNotEmpty) {
              totalDuration = values.reduce((value, element) => value + element);
            }
            result = _formatDuration(totalDuration);
          }
        }
      }
    }
    return result ?? '';
  }

  String _formatDuration(Duration duration) {
    return 'Total time = ${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue,style:  GoogleFonts.acme(fontSize: 16, ),),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          String value;
          var type = e.runtimeType;
          value = e.value.toString();
          if(type == DataGridCell<Duration>){
            Duration d = e.value as Duration;
            value = '${d.inHours}:${d.inMinutes.remainder(60)}';
          }
          if(type == DataGridCell<List<DateTime>>){
            DateTime d1 = e.value[0];
            DateTime d2 = e.value[1];
            String d1Format = DateFormat.yMEd().format(d1);
            String d2Format = DateFormat.yMEd().format(d2);
            String t1Format = DateFormat.jm().format(d1);
            String t2Format = DateFormat.jm().format(d2);
            String time = '$t1Format-$t2Format';
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  d1Format,
                  style: Constants.tableCellStyle
                ),
                Text(
                  d2Format,
                  style: Constants.tableCellStyle
                ),
                Text(
                  time,
                  style: Constants.tableCellStyle,
                ),
              ],
            );
          }
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(
              value,
              style: Constants.tableCellStyle,
            ),
          );
        }).toList());
  }
}