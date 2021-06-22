import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.lato(color: Colors.black54),
    border: new OutlineInputBorder(
      borderRadius: new BorderRadius.circular(25.0),
      borderSide: new BorderSide(),
    ),
  );
}

TextStyle simpleTextStyle() {
  return GoogleFonts.lato(
      textStyle: TextStyle(color: MyColors.primColor, fontSize: 16));
}

TextStyle chatTileStyle() {
  return GoogleFonts.lato(
    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
  );
}
