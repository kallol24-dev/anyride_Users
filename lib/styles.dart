import 'package:flutter/material.dart';

class AppColor extends Color {
  AppColor(int value) : super(value);

  static const backgroundColorDark = Colors.white;
  static const backgroundColorLight = Color(0xFFfdfef9);

  static const buttonColor = Colors.green;
}

ButtonStyle primaryButton = ElevatedButton.styleFrom(
  backgroundColor: AppColor.buttonColor,
  padding: EdgeInsets.only(top: 13, bottom: 13),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
);
