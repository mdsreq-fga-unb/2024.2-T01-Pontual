import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'Inter',
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 18), // Replaces bodyText1
    labelLarge: TextStyle(color: Colors.white), // Replaces button
  ),
);
