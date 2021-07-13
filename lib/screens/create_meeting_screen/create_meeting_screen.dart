import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/screens/meet_screen/meet_screen.dart';
import 'package:teams/utils/firebase_utils.dart';
import 'package:teams/widgets/custom_button.dart';

import 'instructions.dart';


class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({Key? key}) : super(key: key);

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Instructions(),
            CustomButton(
              label: StringConstants.createMeeting,
              onTap: () {
                String roomId = FirebaseUtils.roomCollection.doc().id;
                FirebaseUtils.roomCollection.doc(roomId).set({
                  StringConstants.roomCode: roomId.substring(0, 6),
                  StringConstants.users: [FirebaseUtils.userId()]
                }).then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeetScreen(
                        roomId: roomId,
                      ),
                    ),
                  );
                }, onError: (error) {
                  print(error);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
