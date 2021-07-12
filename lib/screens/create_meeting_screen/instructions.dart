import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';

class Instructions extends StatelessWidget {
  const Instructions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Instructions...",
          style: customTextStyle(
            20,
            Colors.black,
            FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "1. Create meeting by clicking on the button",
          style: customTextStyle(
            18,
            Colors.black,
            FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "2. Click on share button to share with your friends",
          style: customTextStyle(
            18,
            Colors.black,
            FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
