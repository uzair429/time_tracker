import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/widgets/custom_row.dart';

class PunchScreenGuide extends StatelessWidget {
  const PunchScreenGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:  Center(
          child: Text(
            'USER GUIDE',
            style: Constants.appBarTextStyle,
          ),
        ),
      ),
      body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Puch Shift:',
                style: GoogleFonts.acme(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: Constants.primaryColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(17.0),
              child: Column(
                children: [
                  CustomRow(text: 'The start time is pre-selected and the timer starts automatically. Change it if needed.'),
                  CustomRow(text: 'Subtract break time from the total duration by tapping the "Add Break" button. Enter break duration'),
                  CustomRow(text: 'Optionally, add a note or description for the shift.'),
                  CustomRow(text: 'Tap "Punch Out" to end the shift. The current time will be set as the end time, and the shift details will be added.'),

                ],
              ),
            ),
          ]),
    );
  }
}