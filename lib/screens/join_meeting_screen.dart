import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';
import 'package:teams/widgets/custom_button.dart';
import 'package:teams/widgets/custom_snackbars.dart';

import 'meet_screen/meet_screen.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({Key? key}) : super(key: key);

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  String roomCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              "Room code",
              style: customTextStyle(20),
            ),
            const SizedBox(
              height: 20,
            ),
            PinCodeTextField(
              appContext: context,
              autoDisposeControllers: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(shape: PinCodeFieldShape.underline),
              length: 6,
              animationDuration: const Duration(
                milliseconds: 300,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.length != 6) return "Enter the code properly";
                return "";
              },
              onChanged: (value) {
                roomCode = value;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
              label: "Join Meeting",
              onTap: () {
                FirebaseUtils.roomCollection
                    .where("roomCode", isEqualTo: roomCode)
                    .get()
                    .then((snapShot) {
                  if (snapShot.docs.isEmpty) {
                    SnackBar snackBar = customSnackBar(
                        "The room code doesn't exist! Please check the code again");
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    dynamic data = snapShot.docs[0].data();
                    String roomId = snapShot.docs[0].id;
                    List<String> users = data["users"].cast<String>();
                    if (users.length != 1) {
                      SnackBar snackBar =
                          customSnackBar("Meet limit exceeded");
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      users.add(FirebaseUtils.auth.currentUser!.uid);
                      FirebaseUtils.roomCollection
                          .doc(roomId)
                          .update({"users": users});
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetScreen(
                            roomCode: roomCode,
                            roomId: roomId,
                          ),
                        ),
                      );
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
