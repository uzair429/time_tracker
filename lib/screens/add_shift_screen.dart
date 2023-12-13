import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/constants.dart';
import 'package:work_time_tracker/controller/add_shift_controller.dart';
import 'package:work_time_tracker/user_guide_screens/add_screen_guide.dart';
import 'package:work_time_tracker/widgets/build_from.dart';
import 'package:work_time_tracker/widgets/build_note.dart';
import 'package:work_time_tracker/widgets/build_to.dart';
import '../widgets/build_editting_action.dart';

class AddShiftScreen extends StatefulWidget {
  const AddShiftScreen({Key? key}) : super(key: key);

  @override
  State<AddShiftScreen> createState() => _AddShiftScreenState();
}

class _AddShiftScreenState extends State<AddShiftScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddShiftController>(context, listen: false);
    return Scaffold(
      backgroundColor: Constants.scafoldColr,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
        iconTheme: const IconThemeData(
          color: Constants.primaryColor,
          size: 35,
        ),
        actions:[
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddScreenGuide();
                }));
              },
              icon: Constants.info),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BuildFrom(),
              const BuildTo(),
              BuildNote(controller:provider.note),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: 65,
                  child: const BuildEditingAction())
            ],
          ),
        ),
      ),
    );
  }
}