import 'package:flutter/material.dart';
import 'package:work_time_tracker/constants.dart';

class BuildHeader extends StatelessWidget {
  final header;
  final child;
  const BuildHeader({Key? key,required this.header, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Constants.primaryColor.withOpacity(.7),
        ),

        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: Constants.headerStyle
              // TextStyle(fontWeight: FontWeight.normal, fontSize: 22),
            ),
            child
          ],
        ),
      ),
    );
  }
}
