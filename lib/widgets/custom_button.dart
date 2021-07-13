import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/theme/gradients.dart';

import 'custom_snackbars.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onTap;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SnackBar snackBar = customSnackBarWithIndicator();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        onTap();
      },
      child: Container(
        child: Center(
          child: Text(
            label,
            style: customTextStyle(20, Colors.white),
          ),
        ),
        width: double.maxFinite,
        height: 64,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Gradients.indigo,
          ),
        ),
      ),
    );
  }
}
