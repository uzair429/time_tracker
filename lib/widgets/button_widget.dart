import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatelessWidget {
  final String image;
  final Function() onTap;
  final String name;
  const ButtonWidget({Key? key,required this.name, required this.image, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
          width: width * .8,
          child: Stack(
            children: [
              Image.asset(image),
               Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    style: GoogleFonts.acme(
                        fontSize: 33,
                        color: Colors.black.withOpacity(.7),
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
