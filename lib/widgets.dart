import 'package:flutter/material.dart';

import 'constants/colors.dart';

TextButton closeTextButton(BuildContext context) => TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text(
      "Close",
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ColorPalette.deleteColor),
    ));
