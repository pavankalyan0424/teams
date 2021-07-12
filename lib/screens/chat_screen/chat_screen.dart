import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';

import 'input_field.dart';
import 'messages.dart';

class ChatScreen extends StatefulWidget {
  final String localUid;
  final String conId;
  final String remoteUid;

  const ChatScreen(
      {Key? key,
      required this.localUid,
      required this.conId,
      required this.remoteUid})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
         "Chat",
         style: customTextStyle(
            17,Colors.indigoAccent,
         ),
            ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Messages(
            conUid: widget.conId,
            localUid: widget.localUid,
          ),
          InputField(
            conId: widget.conId,
            localUid: widget.localUid,
          ),
        ],
      ),
    );
  }
}
