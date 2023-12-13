import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/controller/start_shift_controller.dart';
import '../controller/organization_controller.dart';
import '../user_guide_screens/puch_screen_guide.dart';
import '../utils/utils.dart';
import '../widgets/build_drop_down_field.dart';
import '../widgets/build_header.dart';
import '../widgets/build_note.dart';

class StartShiftScreen extends StatefulWidget {
  const StartShiftScreen({Key? key}) : super(key: key);

  @override
  State<StartShiftScreen> createState() => _StartShiftScreenState();
}

class _StartShiftScreenState extends State<StartShiftScreen> {
  late final StartShiftController provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<StartShiftController>(context, listen: false);
    initialize();
  }

  void initialize() async {
    await provider.isShiftRun();
    await provider.getTotalBreak();
    if (!provider.isShiftRunning) {
      provider.startShift();
    }
    showDialogBox();
  }

  showDialogBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Constants.scafoldColr,
            title: Center(
                child: Text(
              'Shift Has Been Started!',
              style: GoogleFonts.acme(
                fontSize: 22,
              ),
            )),
            content: Text(
              'SHFIT STARTED AT ${DateFormat('MMM d, h:mm a').format(provider.startDate)}',
              style: GoogleFonts.acme(
                fontSize: 18,
              ),
            ),
            actions: [
              Center(
                  child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK')))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Constants.primaryColor,
          size: 35,
        ),
        actions: [
          CloseButton(
            onPressed: () {
              provider.disposeShift();
              Navigator.of(context).pop();
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return PunchScreenGuide();
                }));
              },
              icon: Constants.info),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BuildStartFrom(),
              BreakButton(),
              TotalDuration(),
              BuildNote(
                controller: provider.startShiftNoteController,
              ),
              BuildHeader(
                  header: 'ATTENTION!',
                  child: Text(
                      'When you punch out, the current time will be your end time')),
              BuildPunchOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalDuration extends StatelessWidget {
  const TotalDuration({Key? key}) : super(key: key);

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StartShiftController>(context);
    return BuildHeader(
        header: "Total Duration",
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_formatDuration(provider.totalBreakDuration)),
            )));
  }
}

class BreakButton extends StatelessWidget {
  const BreakButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StartShiftController>(context);
    return BuildHeader(
        header: "Add Break",
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: provider.breakController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Add Break in (minutes)',
                    border: InputBorder.none),
              ),
            ),
            TextButton(
                onPressed: () {
                  provider.addBreak();
                },
                child: Text(
                  'Add',
                  style: GoogleFonts.acme(fontSize: 18),
                ))
          ],
        ));
  }
}

class BuildPunchOutButton extends StatelessWidget {
  const BuildPunchOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      width: 250,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            final provider =
                Provider.of<StartShiftController>(context, listen: false);
            final orgController =
                Provider.of<OrganizationController>(context, listen: false);
            final endTime = DateTime.now();
            Duration spent = endTime.difference(provider.startDate);
            spent = spent - provider.totalBreakDuration;
            print('this is the start date ${provider.startDate}');

            provider.addShiftEntry2(
              context: context,
              organizationName: orgController.selectedOrganization,
              startTime: provider.startDate,
              endTime: endTime,
              timeSpent: spent,
              note: provider.startShiftNoteController,
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: Constants.primaryColor
          ),
          child: Text('PUNCH OUT',style: Constants.buttonStyle,)),
    );
  }
}

class BuildStartFrom extends StatelessWidget {
  const BuildStartFrom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StartShiftController>(context);
    return BuildHeader(
      header: "Starting Date and Time",
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  Utils.toDate(
                    provider.startDate,
                  ),
                  style: Constants.valueStyle,
                ),
              )),
          // Expanded(
          //     flex: 2,
          //     child: BuildDropDownField(
          //       text: Utils.toDate(provider.startDate),
          //       onClicked: () {
          //         provider.pickStartDateTime(context: context, pickDate: true);
          //       },
          //     )),
          Expanded(
              child: BuildDropDownField(
            text: Utils.toTime(provider.startDate),
            onClicked: () {
              provider.pickStartDateTime(context: context, pickDate: false);
            },
          )),
        ],
      ),
    );
  }
}
