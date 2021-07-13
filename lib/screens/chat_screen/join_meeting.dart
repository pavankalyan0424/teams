import 'package:flutter/material.dart';
import 'package:teams/screens/meet_screen/meet_screen.dart';
import 'package:teams/utils/firebase_utils.dart';

class JoinMeeting extends StatelessWidget {
  const JoinMeeting({
    Key? key,
    required this.conId,
    required this.localUid,
  }) : super(key: key);

  final String conId;
  final String localUid;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.video_call),
      onPressed: () {
        String roomId = FirebaseUtils.roomCollection.doc().id;
        FirebaseUtils.roomCollection.doc(roomId).set({
          "roomCode": roomId.substring(0, 6),
          "users": [FirebaseUtils.auth.currentUser!.uid]
        }).then(
              (value) {
            FirebaseUtils.messageCollection
                .doc(conId)
                .collection(conId)
                .doc()
                .set({
              "message":
              "Hey lets have a video conversation, Here is the roomId: ${roomId.substring(0, 6)}",
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "sentBy": localUid,
            },);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MeetScreen(
                  roomCode: roomId.substring(0, 6),
                  roomId: roomId,
                ),
              ),
            );
          },
          onError: (error) {
            print(error);
          },
        );
      },
    );
  }
}
