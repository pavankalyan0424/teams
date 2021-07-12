import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

import 'input_field.dart';
import 'messages.dart';

class ChatScreen extends StatefulWidget {
  final String localUid;
  final String remoteUid;

  const ChatScreen({Key? key, required this.localUid, required this.remoteUid})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String conId;

  @override
  void initState() {
    super.initState();
    conId = widget.localUid.hashCode <= widget.remoteUid.hashCode
        ? widget.localUid + '_' + widget.remoteUid
        : widget.remoteUid + '_' + widget.localUid;
    checkIfUpdated();
  }

  void checkIfUpdated() async {
    FirebaseUtils.messageCollection.doc(conId).get().then((documentSnapShot) {
      if (!documentSnapShot.exists) {
        FirebaseUtils.messageCollection.doc(conId).set({
          "users": [widget.localUid, widget.remoteUid]
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: customTextStyle(
            17,
            Colors.indigoAccent,
          ),
        ),
      ),
      body: Column(
        children: [
          Messages(
            conUid: conId,
            localUid: widget.localUid,
          ),
          InputField(
            conId: conId,
            localUid: widget.localUid,
          ),
        ],
      ),
    );
  }
}
