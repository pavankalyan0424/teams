import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teams/constants/values.dart';
import 'package:teams/theme/custom_textstyle.dart';

class DropDown extends StatefulWidget {
  final bool userJoined;
  final String roomCode;

  const DropDown({
    Key? key,
    required this.userJoined,
    required this.roomCode,
  }) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List<String> choices = <String>[Values.message, Values.share];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          child: Text(
            widget.userJoined ? Values.message : Values.share,
            style: customTextStyle(17, Colors.black),
          ),
          value: widget.userJoined ? Values.message : Values.share,
        )
      ],
    );
  }

  void choiceAction(String choice) {
    if (choice == Values.message) {
    } else {
      Share.share(Values.shareMessage + widget.roomCode);
    }
  }
}
