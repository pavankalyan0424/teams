import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

import 'input_field.dart';
import 'join_meeting.dart';
import 'messages.dart';
import 'remote_user_tile.dart';

class ChatScreen extends StatefulWidget {
  final String localUid;
  final String remoteUid;
  final bool fromMeetScreen;

  const ChatScreen(
      {Key? key,
      required this.localUid,
      required this.remoteUid,
      required this.fromMeetScreen})
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
        title: widget.fromMeetScreen
            ? Text(
                "Chat",
                style: customTextStyle(
                  17,
                  Colors.indigoAccent,
                ),
              )
            : RemoteUserTile(
                remoteUid: widget.remoteUid,
              ),
        actions: [
          widget.fromMeetScreen
              ? Container()
              : JoinMeeting(
                  conId: conId,
                  localUid: widget.localUid,
                ),
        ],
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
