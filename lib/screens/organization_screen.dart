import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/main.dart';
import 'package:work_time_tracker/screens/add_org_name_screen.dart';

import '../controller/organization_controller.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OrganizationController>(context);

    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Companies you work',style: Constants.appBarTextStyle,),
      ),
      body: provider.organizations.isEmpty
          ? const Center(
        child: Text('No organizations available.'),
      )
          : ListView.builder(
        itemCount: provider.organizations.length,
        itemBuilder: (context, index) {
          var organization = provider.organizations[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Constants.primaryColor,
              child: ListTile(
                onLongPress: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                        title: Text('Are you sure to delete?'),
                    actions: [
                      ElevatedButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('CANCEL'),),
                      ElevatedButton(
                        onPressed: (){
                          provider.deleteOrganization(organization.organizationName);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                            return MyApp();
                          }));
                        },
                        child: Text('DELETE'),)
                    ]
                  );
                });
                },
                onTap: (){
                  provider.selectedOrg(
                      orgName : organization.organizationName,
                      orgPrice: double.parse(organization.orgPrice));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return MyHomePage();
                  }));
                },
                leading: Icon(Icons.business_rounded,size: 55,color: Colors.black,),
                title: Text('${organization.organizationName}',style: GoogleFonts.acme(fontSize: 20),),
               subtitle: Text('Price: ${organization.orgPrice}',style: GoogleFonts.acme(fontSize: 20)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return AddOrgNameScreen();
          }));
        },
        backgroundColor: Constants.primaryColor,
        child: Text('Add',style: GoogleFonts.acme(fontSize: 18),),
      ),
    );
  }
}
