import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/main.dart';
import 'package:work_time_tracker/models/organization_model.dart';
import 'package:work_time_tracker/widgets/custom_snack_bar.dart';

import '../helper/database_helper.dart';

class AddOrgNameScreen extends StatelessWidget {
  AddOrgNameScreen({Key? key}) : super(key: key);

  TextEditingController orgNameController = TextEditingController();
  TextEditingController orgPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Add company you work in',
          style: Constants.appBarTextStyle,),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the desired color for the back button
        ),
      ),
      body:  Padding(
        padding:  const EdgeInsets.all(Constants.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: orgNameController,
              decoration:  InputDecoration(
                  border: InputBorder.none,
               enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(12),
                   borderSide: const BorderSide(color: Constants.primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Constants.primaryColor)),
                  labelText: 'Organization Name',
                labelStyle: GoogleFonts.acme(color: Constants.primaryColor,)
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: orgPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Constants.primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Constants.primaryColor)),
                  labelStyle: GoogleFonts.acme(color: Constants.primaryColor,),
                  labelText: 'Organization Price per hour',),
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              height: 65,
              child: ElevatedButton(
                onPressed: () async {
                  String orgName = orgNameController.text.trim();
                  String orgPrice = orgPriceController.text.trim();

                  if (orgName.isNotEmpty && orgPrice.isNotEmpty) {
                    OrganizationModel orgModel = OrganizationModel(organizationName: orgName,orgPrice: orgPrice);
                    int result = await DatabaseHelper().insertOrganization(orgModel);

                    CustomSnackBar.show(context, 'result is $result');
                    print(result);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                  ),
                ),
                child: Text('Add Organization',style: GoogleFonts.acme(color: Colors.white,fontSize: 25),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
