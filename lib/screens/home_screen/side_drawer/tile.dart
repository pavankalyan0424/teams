import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';

class Tile extends StatelessWidget {
  final String title;
  final Function onTap;

  const Tile({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: customTextStyle(20, Colors.black),
      ),
      onTap: () => onTap(),
    );
  }
}
