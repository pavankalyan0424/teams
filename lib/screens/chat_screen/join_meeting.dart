import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
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
        String roomCode = roomId.substring(0, 6);
        FirebaseUtils.roomCollection.doc(roomId).set({
          StringConstants.roomCode: roomCode,
          StringConstants.users: [
            FirebaseUtils.userId(),
          ]
        }).then(
          (value) {
            FirebaseUtils.messageCollection
                .doc(conId)
                .collection(conId)
                .doc()
                .set(
              {
                StringConstants.message:
                    "${StringConstants.chatMessage} $roomCode",
                StringConstants.timestamp: DateTime.now().millisecondsSinceEpoch,
                StringConstants.sentBy: localUid,
              },
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MeetScreen(
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
