import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/widgets/build_drop_down_field.dart';
import 'package:work_time_tracker/widgets/build_header.dart';

import '../controller/add_shift_controller.dart';
import '../utils/utils.dart';

class BuildTo extends StatelessWidget {
  const BuildTo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addShiftController = Provider.of<AddShiftController>(context);
    return BuildHeader(
      header: "End Date And Time",
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: BuildDropDownField(
                  text: Utils.toDate(addShiftController.toDate),
                  onClicked: () => addShiftController.pickToDateTime(context: context, pickDate: true)
              )),
          Expanded(
              child: BuildDropDownField(
                text: Utils.toTime(addShiftController.toDate),
                onClicked: () => addShiftController.pickToDateTime(context: context, pickDate: false),
              )),
        ],
      ),
    );
  }
}
