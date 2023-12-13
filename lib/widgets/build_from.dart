import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/controller/add_shift_controller.dart';
import 'package:work_time_tracker/widgets/build_drop_down_field.dart';
import 'package:work_time_tracker/widgets/build_header.dart';
import '../utils/utils.dart';

class BuildFrom extends StatelessWidget {
  const BuildFrom({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addShiftController = Provider.of<AddShiftController>(context);
    return BuildHeader(
      header: "Starting Date and Time",
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: BuildDropDownField(
                text: Utils.toDate(addShiftController.fromDate),
                onClicked: () {
                  addShiftController.pickFromDateTime(
                      context: context, pickDate: true);
                },
              )),
          Expanded(
              child: BuildDropDownField(
            text: Utils.toTime(addShiftController.fromDate),
            onClicked: () {
              addShiftController.pickFromDateTime(
                  context: context, pickDate: false);
            },
          )),
        ],
      ),
    );
  }
}
