import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teams/constants/variables.dart';

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
  List<String> choices = <String>["Message", "Share"];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          child: Text(
            widget.userJoined ? "Message" : "Share",
            style: myStyle(17, Colors.black),
          ),
          value: widget.userJoined ? "Message" : "Share",
        )
      ],
    );
  }

  void choiceAction(String choice) {
    if (choice == "Message") {
    } else {
      Share.share(
          "hey there, I am waiting for you; Here is the room Code: ${widget.roomCode}");
    }
  }
}
