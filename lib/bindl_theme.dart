import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColorLight = Color.fromRGBO(237, 162, 93, 1);
const secondaryColorLight = Color.fromRGBO(93, 168, 237, 1);
const overlineColorLight = Color.fromRGBO(255, 255, 255, 0.4);
const backgorundColorLight = Color.fromRGBO(255, 255, 255, 1);
const backgroundCardColorLight = Color.fromRGBO(255, 255, 255, 1);
const disabledColorLight = Colors.grey;

const primaryColorDark = Color.fromRGBO(237, 162, 93, 1);
const secondaryColorDark = Color.fromRGBO(93, 168, 237, 1);
const overlineColorDark = Color.fromRGBO(33, 33, 33, 0.4);
const backgroundColorDark = Color.fromRGBO(33, 33, 33, 1);
const backgroundCardColorDark = Color.fromRGBO(66, 66, 66, 66);
const disabledColorDark = Colors.grey;

class BindlTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyText2: GoogleFonts.openSans(
      fontSize: 16,
      // fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    subtitle1: GoogleFonts.openSans(
      fontSize: 14,
      // fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    subtitle2: GoogleFonts.openSans(
      fontSize: 13,
      color: Colors.black,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black.withOpacity(0.8),
    ),
    overline: GoogleFonts.openSans(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      letterSpacing: 0,
      backgroundColor: overlineColorLight,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.openSans(
      fontSize: 16,
      // fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.openSans(
      fontSize: 14,
      // fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    subtitle2: GoogleFonts.openSans(
      fontSize: 13,
      color: Colors.white,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white.withOpacity(0.8),
    ),
    overline: GoogleFonts.openSans(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0,
      backgroundColor: overlineColorDark,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: primaryColorLight,
        secondary: secondaryColorLight,
        secondaryVariant: disabledColorLight,
        brightness: Brightness.light,
      ),
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: primaryColorLight,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: secondaryColorLight,
        selectedLabelStyle: lightTextTheme.subtitle1,
        unselectedLabelStyle: lightTextTheme.subtitle2,
        selectedIconTheme: IconThemeData(size: 28),
      ),
      textTheme: lightTextTheme,
      chipTheme: const ChipThemeData(
        backgroundColor: Colors.grey,
        disabledColor: secondaryColorLight,
        selectedColor: primaryColorLight,
        secondarySelectedColor: primaryColorLight,
        padding: EdgeInsets.all(4),
        labelStyle: TextStyle(),
        secondaryLabelStyle: TextStyle(),
        brightness: Brightness.dark,
        deleteIconColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.black,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      shadowColor: backgorundColorLight,
      cardColor: backgroundCardColorLight,
      dividerColor: backgroundColorDark,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: primaryColorDark,
        secondary: secondaryColorDark,
        secondaryVariant: disabledColorDark,
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: primaryColorDark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryColorDark,
      ),
      textTheme: darkTextTheme,
      chipTheme: const ChipThemeData(
        backgroundColor: Colors.grey,
        disabledColor: secondaryColorDark,
        selectedColor: primaryColorDark,
        secondarySelectedColor: primaryColorDark,
        padding: EdgeInsets.all(4),
        labelStyle: TextStyle(),
        secondaryLabelStyle: TextStyle(),
        brightness: Brightness.dark,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: TextStyle(color: Colors.black),
      ),
      shadowColor: backgroundColorDark,
      cardColor: backgroundCardColorDark,
      dividerColor: backgorundColorLight,
    );
  }
}
