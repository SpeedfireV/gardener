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

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        elevation: 5, // Now applies actual elevation
        borderRadius: BorderRadius.circular(15),
        color: ColorPalette.cardColor, // Background color
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 40,
            color: ColorPalette.primaryTextColor, // Icon color
          ),
        ),
      ),
    );
  }
}
