import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/screens/meet_screen/meet_screen.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/theme/gradients.dart';
import 'package:teams/utils/firebase_utils.dart';
import 'package:teams/widgets/custom_button.dart';
import 'package:teams/widgets/custom_oval_bottom.dart';
import 'package:teams/widgets/custom_snackbars.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({Key? key}) : super(key: key);

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  String roomCode = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomOvalBottom(),
            child: Container(
              width: width,
              height: height / 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: Gradients.indigo,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: height / 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join Meeting",
                  style: customTextStyle(25, Colors.white, FontWeight.bold),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Room code",
                    style: customTextStyle(20,Colors.indigoAccent),
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
                    label: StringConstants.joinMeeting,
                    onTap: () {
                      FirebaseUtils.roomCollection
                          .where(StringConstants.roomCode, isEqualTo: roomCode)
                          .get()
                          .then(
                        (snapShot) {
                          if (snapShot.docs.isEmpty) {
                            SnackBar snackBar =
                                customSnackBar(StringConstants.roomCodeError);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            dynamic data = snapShot.docs[0].data();
                            String roomId = snapShot.docs[0].id;
                            List<String> users =
                                data[StringConstants.users].cast<String>();
                            if (users.length != 1) {
                              SnackBar snackBar =
                                  customSnackBar(StringConstants.limitExceed);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              users.add(FirebaseUtils.userId());
                              FirebaseUtils.roomCollection
                                  .doc(roomId)
                                  .update({StringConstants.users: users});
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MeetScreen(
                                    roomId: roomId,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
