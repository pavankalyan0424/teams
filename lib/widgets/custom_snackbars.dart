import 'package:flutter/material.dart';
import 'package:teams/constants/values.dart';
import 'package:teams/theme/custom_textstyle.dart';

SnackBar customSnackBar(String text) {
  return SnackBar(
    content: Text(
      text,
      style: customTextStyle(
        20,
      ),
    ),
    duration: const Duration(seconds: 3),
  );
}

SnackBar customSnackBarWithIndicator([int seconds = 3]) {
  return SnackBar(
    content: Row(
      children: [
        Text(
          Values.loading,
          style: customTextStyle(
            20,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const CircularProgressIndicator(),
      ],
    ),
    duration: const Duration(seconds: 2),
  );
}
