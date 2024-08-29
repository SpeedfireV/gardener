import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  static TextStyle dialogTitleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: ColorPalette.primaryTextColor);
  static TextStyle titleTextStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      color: ColorPalette.primaryTextColor);
}

class Paddings {
  static EdgeInsets dialogPadding =
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12);
}
