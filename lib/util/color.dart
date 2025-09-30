import 'package:flutter/material.dart';

Color getWhiteOrBlackColor({
  required Color backgroundColor,
  required Color whiteColor,
  required Color blackColor,
}) => ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ? whiteColor : blackColor;
