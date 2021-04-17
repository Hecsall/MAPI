import 'package:flutter/material.dart';


const StatusColors = {
  'ongoing': Colors.blue,
  'complete': Colors.green,
  'hiatus': Colors.red,
};


// ###########
// Light Theme
// ###########
const Color lightPrimaryColor = Color(0xFFF9F9F9);
const Color lightTextColor = Color(0xff131212);


// ###########
// Dark Theme
// ###########

// App background
const Color darkPrimaryColor = Color(0xFF202328);
const Color darkSecondaryColor = Color(0xFF2A2F36);
const Color darkTextColor = Color(0xffffffff);


// Define Black color because black lives matter
const MaterialColor primaryBlack = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);


const MaterialColor primaryDark = MaterialColor(
  0xFF202328,
  <int, Color>{
    50: darkPrimaryColor,
    100: darkPrimaryColor,
    200: darkPrimaryColor,
    300: darkPrimaryColor,
    400: darkPrimaryColor,
    500: darkPrimaryColor,
    600: darkPrimaryColor,
    700: darkPrimaryColor,
    800: darkPrimaryColor,
    900: darkPrimaryColor,
  },
);


const MaterialColor primaryLight = MaterialColor(
  0xFFF9F9F9,
  <int, Color>{
    50: lightPrimaryColor,
    100: lightPrimaryColor,
    200: lightPrimaryColor,
    300: lightPrimaryColor,
    400: lightPrimaryColor,
    500: lightPrimaryColor,
    600: lightPrimaryColor,
    700: lightPrimaryColor,
    800: lightPrimaryColor,
    900: lightPrimaryColor,
  },
);

