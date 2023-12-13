import 'package:flutter/material.dart';

import '../constants.dart';

class BuildDropDownField extends StatelessWidget {
  final text;
  final onClicked;
  const BuildDropDownField({Key? key,required this.text, required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(text,style: Constants.valueStyle,),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }
}
