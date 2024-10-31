import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  final BoxDecoration gradientBox = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xff021024),
            Color(0xff052659),
            Color(0xff5483B3),
            Color(0xff7DA0CA),
            Color(0xffC1E8FF)
          ],
          tileMode: TileMode.clamp));
  final Container appbarGradien = Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xff7DA0CA), Color(0xffC1E8FF)])),
  );
  final primaryColor = const Color(0xFFE6E6FA);
  final secondColor = const Color(0xff7DA0CA);
  final box_key = 'ContryBox';
  final table_key = 'ContryList';
  final text_color = Colors.deepPurple;
  final String apiKey = "36d8394601794947a25125410242210";
  final TextStyle fontfamily = GoogleFonts.oxanium(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    shadows: [
      const Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 10.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ],
  );
  final barColor = const Color(0xff052659);
}
