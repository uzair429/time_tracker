import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/widgets/custom_row.dart';

class AddScreenGuide extends StatelessWidget {
  const AddScreenGuide({Key? key}) : super(key: key);

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
                'Add time:',
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
                  CustomRow(text: 'Tap to choose the starting date for the new entry.'),
                  CustomRow(text: 'Tap to choose the ending date for the new entry.'),
                  CustomRow(text: 'Enter a note or description for the entry.'),
                  CustomRow(text: 'Use the "Save" button to save the entered details and add the new entry.'),

                ],
              ),
            ),
          ]),
    );
  }
}