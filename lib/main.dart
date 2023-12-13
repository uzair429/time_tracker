import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/controller/add_shift_controller.dart';
import 'package:work_time_tracker/controller/organization_controller.dart';
import 'package:work_time_tracker/controller/start_shift_controller.dart';
import 'package:work_time_tracker/screens/add_org_name_screen.dart';
import 'package:work_time_tracker/screens/add_shift_screen.dart';
import 'package:work_time_tracker/screens/organization_screen.dart';
import 'package:work_time_tracker/screens/shift_detail_screen.dart';
import 'package:work_time_tracker/screens/start_shift_screen.dart';
import 'package:work_time_tracker/user_guide_screens/main_screen_guide.dart';
import 'package:work_time_tracker/widgets/button_widget.dart';

import 'constants.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AddShiftController>(
        create: (_) => AddShiftController(),
      ),
      ChangeNotifierProvider<StartShiftController>(
        create: (_) => StartShiftController(),
      ),
      ChangeNotifierProvider<OrganizationController>(
        create: (_) => OrganizationController(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final OrganizationController provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<OrganizationController>(context, listen: false);
    initialize();
  }

  initialize() async {
    await provider.fetchOrganizations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(provider.organizations);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.primaryColor),
        // useMaterial3: true,
      ),
      home: provider.organizations.isEmpty || provider.organizationCount == 1
          ? MyHomePage()
          : OrganizationScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final StartShiftController provider;
  late final OrganizationController orgController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<StartShiftController>(context, listen: false);
    orgController = Provider.of<OrganizationController>(context, listen: false);
    initialize();
  }

  void initialize() async {
    await provider.isShiftRun();
  }

  @override
  Widget build(BuildContext context) {
    final startController = Provider.of<StartShiftController>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    print(startController.isShiftRunning);

    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
            child: Text(
                orgController.selectedOrganization ?? '',
              style: Constants.appBarTextStyle,
            )),
        actions: [
          if (orgController.organizationCount == 1)
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return AddOrgNameScreen();
                  }));
                },
                icon: Constants.add),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MainScreenGuide();
                }));
              },
              icon: const Icon(Icons.info_outline,color: Constants.primaryColor,size: 33,)),
        ],
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
                name: 'Add shift',
                image: 'assets/images/button_one.png',
                onTap: () async {
                  if (orgController.selectedOrganization == null) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddOrgNameScreen();
                    }));
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddShiftScreen();
                    }));
                  }
                },),
            const SizedBox(
              height: 5,
            ),
            ButtonWidget(
                name:  'Punch shift ${startController.isShiftRunning ? ' (R)' : ''}', // 'punch shift',
                image: 'assets/images/button_two.png',
                onTap: () async {
          if (orgController.selectedOrganization == null) {
            // return;
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return AddOrgNameScreen();
            }));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return StartShiftScreen();
            }));
          }
        },),
            const SizedBox(
              height: 5,
            ),
            ButtonWidget(
                name: 'shift detail',
                image: 'assets/images/button_three.png',
                onTap:  () {
                  if (orgController.selectedOrganization == null) {
                    // return;
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddOrgNameScreen();
                    }));
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ShiftDetailScreen();
                    }));
                  }
                },),

            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //     onPressed: () async {
            //       if (orgController.selectedOrganization == null) {
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(builder: (context) {
            //           return AddOrgNameScreen();
            //         }));
            //       } else {
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(builder: (context) {
            //           return AddShiftScreen();
            //         }));
            //       }
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 65.0),
            //       child: Text(
            //         'ADD SHIFT',
            //         style: TextStyle(fontSize: 20, color: Colors.white),
            //       ),
            //     )),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //     onPressed: () async {
            //       if (orgController.selectedOrganization == null) {
            //         // return;
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(builder: (context) {
            //           return AddOrgNameScreen();
            //         }));
            //       } else {
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(builder: (context) {
            //           return StartShiftScreen();
            //         }));
            //       }
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(
            //           vertical: startController.isShiftRunning ? 6 : 0,
            //           horizontal: startController.isShiftRunning ? 5 : 50.0),
            //       child: Text(
            //         'PUNCH SHIFT ${startController.isShiftRunning ? '(Running)' : ''}',
            //         style: TextStyle(fontSize: 20, color: Colors.white),
            //       ),
            //     )),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //     onPressed: () {
            //       if (orgController.selectedOrganization == null) {
            //         // return;
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(builder: (context) {
            //           return AddOrgNameScreen();
            //         }));
            //       } else {
            //         Navigator.of(context)
            //             .push(MaterialPageRoute(builder: (context) {
            //           return ShiftDetailScreen();
            //         }));
            //       }
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 50.0),
            //       child: Text(
            //         'SHIFT DETAIL ',
            //         style: TextStyle(fontSize: 20, color: Colors.white),
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }
}
