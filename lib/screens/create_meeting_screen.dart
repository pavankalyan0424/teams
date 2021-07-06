import 'package:flutter/material.dart';
import 'package:teams/constants/variables.dart';
import 'package:teams/utils/firebase_utils.dart';

import 'meet_screen.dart';

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
            Text(
              "Instructions...",
              style: myStyle(
                20,
                Colors.black,
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "1. Create meeting by clicking on the button",
              style: myStyle(
                18,
                Colors.black,
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "2. Click on share button to share with your friends",
              style: myStyle(
                18,
                Colors.black,
                FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                String roomId = FirebaseUtils.roomCollection.doc().id;
                await FirebaseUtils.roomCollection.doc(roomId).set({
                  "roomCode": roomId.substring(0, 6),
                  "users": [FirebaseUtils.auth.currentUser!.uid]
                });
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
              child: Container(
                child: Center(
                  child: Text(
                    "Create Meeting",
                    style: myStyle(20, Colors.white),
                  ),
                ),
                width: double.maxFinite,
                height: 64,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF64B5F6),
                      Color(0xFF90CAF9),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
