import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/controller/add_shift_controller.dart';
import 'package:work_time_tracker/controller/organization_controller.dart';
import 'package:work_time_tracker/helper/shift_data_source.dart';
import 'package:work_time_tracker/screens/display_pdf_screen.dart';
import '../models/shift_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;
import 'package:syncfusion_flutter_datagrid_export/export.dart';

class ShiftDetailScreen extends StatefulWidget {
  const ShiftDetailScreen({Key? key}) : super(key: key);

  @override
  State<ShiftDetailScreen> createState() => _ShiftDetailScreenState();
}

class _ShiftDetailScreenState extends State<ShiftDetailScreen> {


  List<ShiftModel> shifts = <ShiftModel>[];
  ShiftDataSource? shiftDataSource;
  late final AddShiftController provider;
  late final OrganizationController orgController;

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {

    super.initState();
    provider = Provider.of<AddShiftController>(context, listen: false);
    initialize();

  }

  initialize() async {
    orgController = Provider.of<OrganizationController>(context, listen: false);
    await provider.loadAllTimeEntries(orgController.selectedOrganization);
    setState(() {
      shifts = provider.allShiftEntries;
    });
    shiftDataSource = ShiftDataSource(shiftData: shifts,context: context);
  }

  Future<void> exportDataGridToPdf() async {
    final PdfDocument document =
    _key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
    final List<int> bytes = await document.save();
    await saveAndLaunchFile(bytes,orgController.selectedOrganization!);
    document.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Shift Detail',style: Constants.appBarTextStyle,),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    backgroundColor: Constants.scafoldColr,
                    title: Text(
                      'Are you sure to create PDF File',
                      style: GoogleFonts.acme(
                      fontSize: 22,
                    ),),
                    actions: [
                      ElevatedButton(
                          onPressed: ()=> Navigator.of(context).pop(),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: (){
                            exportDataGridToPdf();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Create')),
                    ],
                  );
                });
              }
              , icon:  Icon(Icons.picture_as_pdf,size: 30, color:Colors.red.withOpacity(.9),),
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return DisplayPdfScreen();
                }));
          }, child: Text('PDF FILES',style: GoogleFonts.acme(fontSize: 15),))
        ],
      ),
      body : Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    shifts = provider.allShiftEntries;
                  });
                  shiftDataSource = ShiftDataSource(shiftData: shifts, context: context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: const Text('All'),
              ),
              ElevatedButton(
                onPressed: () {
                  final selectedDate = DateTime.now();
                  List<ShiftModel> shiftsInSelectedWeek = provider.allShiftEntries.where((shift) {
                    DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
                    // Check if the shift falls within the selected week
                    return shift.startTime.isAfter(getDate(selectedDate.subtract(Duration(days: selectedDate.weekday - 1)))) &&
                        shift.startTime.isBefore(getDate(selectedDate.add(Duration(days: DateTime.daysPerWeek - selectedDate.weekday))));
                  }).toList();
                  setState(() {
                    shifts = shiftsInSelectedWeek;
                  });
                  shiftDataSource = ShiftDataSource(shiftData: shifts,context: context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                child: const Text('Week'),
              ),
              ElevatedButton(
                onPressed: () {
                  DateTime selectedMonth = DateTime.now();
                  // Filter shifts for the selected month
                  List<ShiftModel> shiftsInSelectedMonth = provider.allShiftEntries.where((shift) {
                    return shift.startTime.year == selectedMonth.year &&
                        shift.startTime.month == selectedMonth.month;
                  }).toList();

                  setState(() {
                    shifts = shiftsInSelectedMonth;
                  });
                  shiftDataSource = ShiftDataSource(shiftData: shifts, context: context);
                  // Handle "Month" button press
                  print('Month button pressed');
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: const Text('Month'),
              ),
              ElevatedButton(
                onPressed: () {
                  DateTime selectedYear = DateTime.now();
                  List<ShiftModel> shiftsInSelectedYear = provider.allShiftEntries.where((shift) {
                    return shift.startTime.year == selectedYear.year;
                  }).toList();
                  setState(() {
                    shifts = shiftsInSelectedYear;
                  });
                  shiftDataSource = ShiftDataSource(shiftData: shifts, context: context);
                  print('Year button pressed');
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: const Text('Year'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          shiftDataSource == null
              ? const Center(child: CircularProgressIndicator()) :
          Expanded(
            child: SfDataGridTheme(
              data: SfDataGridThemeData(
                  headerColor: Constants.primaryColor,
                gridLineColor: Colors.black,
              ),
              child: SfDataGrid(
                key: _key,
                gridLinesVisibility: GridLinesVisibility.both,
                source: shiftDataSource!,
                columnWidthMode: ColumnWidthMode.fill,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'date',
                      label: Container(
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: Text(
                            'Date',
                            style: Constants.tableHeaderStyle,
                          ))
                  ),
                  GridColumn(
                      columnName: 'hours',
                      label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Hours', style: Constants.tableHeaderStyle,))
                  ),
                  GridColumn(
                      columnName: 'note',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child:  Text(
                            'Note',
                            overflow: TextOverflow.ellipsis,
                            style: Constants.tableHeaderStyle,
                          ))
                  ),
                  GridColumn(
                      columnName: 'wages',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child:  Text(
                            'Wages',
                            overflow: TextOverflow.ellipsis,
                            style: Constants.tableHeaderStyle,
                          ))
                  ),

                ],
                onQueryRowHeight: (details) {
                  return details.getIntrinsicRowHeight(details.rowIndex);
                },
                tableSummaryRows: [
                  GridTableSummaryRow(
                      // showSummaryInRow: false,
                      // titleColumnSpan: 3,
                      title: 'hours',
                      showSummaryInRow: true,
                      columns: [
                        const GridSummaryColumn(
                          name: 'hours',
                          columnName: 'hours',
                          summaryType: GridSummaryType.sum,
                        ),
                        const GridSummaryColumn(
                          name: 'wages',
                          columnName: 'wages',
                          summaryType: GridSummaryType.sum,
                        ),
                      ],
                      position: GridTableSummaryRowPosition.bottom)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> saveAndLaunchFile(List<int> bytes,String directoryPath) async {
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {

      Directory root = await path_provider.getApplicationSupportDirectory();

      path = '${root.path}/$directoryPath';
      final Directory directory = Directory(path);

      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }
      path = directory.path;
    }

    final String formattedDateTime = DateFormat('yyMMdd_HHmmss').format(DateTime.now());
    final String fileName = '${directoryPath}_$formattedDateTime.pdf';

    final String fileLocation =
    Platform.isWindows ? '$path\\$fileName' : '$path/$fileName';
    final File file = File(fileLocation);
    await file.writeAsBytes(bytes, flush: true);

    if (Platform.isAndroid || Platform.isIOS) {
      await open_file.OpenFile.open(fileLocation);
    }
  }
}

