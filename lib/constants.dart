import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants{
  
  static const primaryColor = Color(0xff37B6AC);
 static const scafoldColr = Color(0xffc1cecb);
  static const button1 = Color(0xff75e8b7);
  static const button2 = Color(0xff7984FF);
  static const button3 = Color(0xffFF784A);
  static const scaffoldButton1 = Color(0xffbeead7);
  static const scaffoldButton2 = Color(0xffbcc1f1);
  static const scaffoldButton3 = Color(0xffeebfb5);

  static const info = Icon(Icons.info_outline,color: Constants.primaryColor,size: 33,);
  static const add = Icon(Icons.add,color: Constants.primaryColor,size: 33,);

  static TextStyle appBarTextStyle = GoogleFonts.acme(fontSize: 22,color: Constants.primaryColor);

  static TextStyle headerStyle = GoogleFonts.acme(fontSize: 22,color: Colors.black);
  static TextStyle valueStyle = GoogleFonts.acme(fontSize: 16,color: Colors.black);
  static TextStyle tableHeaderStyle = GoogleFonts.acme(fontSize: 15, color: Colors.black);
  static TextStyle tableCellStyle = GoogleFonts.acme(color: Colors.black,fontSize: 12);

  static TextStyle buttonStyle = GoogleFonts.acme(color: Colors.black,fontSize: 25);

  static const double padding = 6;




}