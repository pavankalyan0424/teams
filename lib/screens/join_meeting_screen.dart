import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:teams/constants/variables.dart';
import 'package:teams/utils/firebase_utils.dart';

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                "Room code",
                style: myStyle(20),
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
                height: 10,
              ),
              TextField(
                style: myStyle(20),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Name (Leave if you want your username )",
                  labelStyle: myStyle(15),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () async {
                  int found = 0;
                  FirebaseUtils.roomCollection
                      .where("roomCode", isEqualTo: roomCode)
                      .get()
                      .then((snapShot) {
                    found = 1;
                    dynamic data = snapShot.docs[0].data();
                    print(data["roomCode"]);
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const MeetScreen(
                    //       meetingCode: "",
                    //     ),
                    //   ),
                    // );
                  });
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "Join Meeting",
                      style: myStyle(20, Colors.white),
                    ),
                  ),
                  width: double.maxFinite,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFBBDEFB),
                        Color(0xFF90CAF9),
                        Color(0xFF64B5F6),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
