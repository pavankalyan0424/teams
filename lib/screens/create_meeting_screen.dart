import 'package:flutter/material.dart';
import 'package:teams/constants/variables.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({Key? key}) : super(key: key);

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              "Create a code and share it with your friends",
              style: myStyle(20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Code:",
                style: myStyle(30),
              ),
              Text(
                code,
                style: myStyle(30, Colors.purple, FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: () {
              setState(() {
                // code = Uuid().v1().substring(0, 6);
              });
            },
            child: Container(
              width: width / 2,
              height: 50,
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
              child: Center(
                child: Text(
                  "Create Code",
                  style: myStyle(
                    20,
                    Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
