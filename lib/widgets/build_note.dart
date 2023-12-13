import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_tracker/widgets/build_header.dart';
import '../controller/add_shift_controller.dart';

class BuildNote extends StatelessWidget {
  final TextEditingController controller;
  const BuildNote({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addShiftController = Provider.of<AddShiftController>(context);
    return BuildHeader(
        header: 'NOTE',
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Note',
            border: InputBorder.none
          ),
        ));
  }
}
