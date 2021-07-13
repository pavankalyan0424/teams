import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/screens/chat_screen/reciever_message.dart';
import 'package:teams/screens/chat_screen/sender_message.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key? key,
    required this.conUid,
    required this.localUid,
  }) : super(key: key);

  final String conUid;
  final String localUid;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseUtils.messageCollection
            .doc(conUid)
            .collection(conUid)
            .orderBy(StringConstants.timestamp, descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: customTextStyle(18, Colors.indigoAccent),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> totalMessages =
              snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: totalMessages.length,
            itemBuilder: (context, index) {
              dynamic data = totalMessages[index].data();
              return data[StringConstants.sentBy] == localUid
                  ? SentMessage(
                      message: data[StringConstants.message],
                      timestamp: data[StringConstants.timestamp],
                    )
                  : ReceivedMessage(
                      message: data[StringConstants.message],
                      timestamp: data[StringConstants.timestamp],
                    );
            },
          );
        },
      ),
    );
  }
}
