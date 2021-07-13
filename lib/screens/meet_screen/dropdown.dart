import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/screens/chat_screen/chat_screen.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class DropDown extends StatefulWidget {
  final bool userJoined;
  final String roomId;

  const DropDown({
    Key? key,
    required this.userJoined,
    required this.roomId,
  }) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List<String> choices = <String>[StringConstants.messageText, StringConstants.share];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          child: Text(
            widget.userJoined ? StringConstants.messageText : StringConstants.share,
            style: customTextStyle(17, Colors.black),
          ),
          value: widget.userJoined ? StringConstants.messageText : StringConstants.share,
        )
      ],
    );
  }

  Future<void> choiceAction(String choice) async {
    String localUid = FirebaseUtils.userId();
    late String remoteUid;
    if (choice == StringConstants.messageText) {
      await FirebaseUtils.roomCollection
          .doc(widget.roomId)
          .get()
          .then((documentSnapShot) {
        dynamic data = documentSnapShot.data();
        remoteUid = data[StringConstants.users]
            .singleWhere((e) => e.toString() != localUid)
            .toString();
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            localUid: localUid,
            remoteUid: remoteUid,
            fromMeetScreen: true,
          ),
        ),
      );
    } else {
      Share.share(StringConstants.shareMessage + widget.roomId.substring(0, 6));
    }
  }
}
