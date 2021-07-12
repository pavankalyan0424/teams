import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teams/constants/values.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

import '../chat_screen/chat_screen.dart';

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

  Future<void> choiceAction(String choice) async {
    String localUid = FirebaseUtils.auth.currentUser!.uid;
    late String remoteUid;
    if (choice == Values.message) {
      await FirebaseUtils.roomCollection
          .doc(widget.roomId)
          .get()
          .then((documentSnapShot) {
        dynamic data = documentSnapShot.data();
        remoteUid = data["users"]
            .singleWhere((e) => e.toString() != localUid)
            .toString();
      });

      //conId is conversationId
      String conId = localUid.hashCode <= remoteUid.hashCode
          ? localUid + '_' + remoteUid
          : remoteUid + '_' + localUid;
      FirebaseUtils.messageCollection.doc(conId).get().then((documentSnapShot) {
        dynamic data = documentSnapShot.data();
        if (data["users"] == null) {
          FirebaseUtils.messageCollection.doc(conId).update({
            "users": [localUid, remoteUid]
          });
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            localUid: localUid,
            conId: conId,
            remoteUid: remoteUid,
          ),
        ),
      );
    } else {
      Share.share(Values.shareMessage + widget.roomId.substring(0, 6));
    }
  }
}
