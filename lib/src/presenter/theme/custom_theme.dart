import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData theme() {
    return ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
        fontFamily: 'Arvo');
  }
}
