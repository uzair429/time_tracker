import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/controller/add_shift_controller.dart';
import 'package:work_time_tracker/controller/organization_controller.dart';

import '../constants.dart';

class BuildEditingAction extends StatelessWidget {
  const BuildEditingAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final provider =
        Provider.of<AddShiftController>(context, listen: false);
        final orgController =
        Provider.of<OrganizationController>(context, listen: false);
        final Duration spent = provider.toDate.difference(provider.fromDate);
        provider.addShiftEntry(
          context: context,
            organizationName: orgController.selectedOrganization,
            startTime: provider.fromDate,
            endTime: provider.toDate,
            timeSpent: spent,
          note: provider.note,
        );
      },
      style : ElevatedButton.styleFrom(
        backgroundColor: Constants.primaryColor.withOpacity(.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
        ),
      ),
      child: Text('Save',style: Constants.buttonStyle),
    );
  }
}
