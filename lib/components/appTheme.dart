import 'package:flutter/material.dart';
import 'colors.dart';


/// Set of theme variables for the app.
///
/// Not all colors are customized, and only a few font styles are customized.
ThemeData primaryTheme (String mode) {

  MaterialColor primaryMaterialColor;
  Color primaryTextColor;
  ColorScheme themeColorScheme;

  if(mode == 'light'){
    primaryMaterialColor = primaryLight;
    primaryTextColor = lightTextColor;
    themeColorScheme = ColorScheme(
      primary: const Color(0xff6200ee),
      primaryVariant: const Color(0xff3700b3),
      secondary: const Color(0xff03dac6),
      secondaryVariant: const Color(0xff018786),
      surface: Colors.white,
      background: lightPrimaryColor,
      error: const Color(0xffb00020),
      onPrimary: Colors.white,
      onSecondary: Colors.grey,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );
  } else {
    primaryMaterialColor = primaryDark;
    primaryTextColor = darkTextColor;
    themeColorScheme = ColorScheme(
      primary: const Color(0xffbb86fc),
      primaryVariant: const Color(0xff3700B3),
      secondary: const Color(0xff03dac6),
      secondaryVariant: const Color(0xff03dac6),
      surface: darkSecondaryColor,
      background: darkPrimaryColor,
      error: const Color(0xffcf6679),
      onPrimary: Colors.black,
      onSecondary: Colors.grey,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    );
  }

  return ThemeData(
    fontFamily: 'Roboto',
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Colors
    primaryColor: primaryMaterialColor,
    scaffoldBackgroundColor: primaryMaterialColor,
    colorScheme: themeColorScheme,

    appBarTheme: null,

    // Style for AppBar text
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        letterSpacing: 1.0,
      ),
    ),

    // Style for Standard text
    textTheme: TextTheme(
      bodyText2: TextStyle(
        color: primaryTextColor,
        fontSize: 13.0,
        height: 1.3
      )
    )

  );

}