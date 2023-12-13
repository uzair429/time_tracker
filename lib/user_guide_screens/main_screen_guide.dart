import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/widgets/custom_row.dart';

class MainScreenGuide extends StatelessWidget {
  const MainScreenGuide({Key? key}) : super(key: key);

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
            'Work Time Activity',
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
              CustomRow(text: 'you can add shift by clicking "ADD SHIFT" Buttoon.'),
              CustomRow(text: 'You can start punch in your shift by clicking "PUNCH SHIFT" Button.'),
              CustomRow(text: 'SHIFT DETAILS" show all your shift detail.'),
              CustomRow(text: 'Tap "+" to add a new organization.'),

            ],
          ),
        ),
      ]),
    );
  }
}
