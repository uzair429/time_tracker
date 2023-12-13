import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class CustomRow extends StatelessWidget {
  final text;

  const CustomRow({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.primaryColor,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(text,
                style: GoogleFonts.acme(
                    fontSize: 18, color: Colors.black.withOpacity(.8))),
          )
        ],
      ),
    );
  }
}
