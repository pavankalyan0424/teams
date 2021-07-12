import 'package:flutter/material.dart';
import 'package:teams/constants/image_paths.dart';
import 'package:teams/constants/values.dart';
import 'package:teams/screens/auth_screen/signin_button.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height / 1.7,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffee0000), Color(0xffeeee00)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      ImagePaths.teamsIcon,
                      height: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hi There!!!",
                    style: customTextStyle(22, Colors.white, FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Login to your account to continue",
                    style: customTextStyle(17, Colors.white, FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width,
              height: height / 2,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SignInButton(
                    imagePath: ImagePaths.googleIcon,
                    label: Values.signInWithGoogle,
                    signInFunction: FirebaseUtils.googleSignIn,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SignInButton(
                    imagePath: ImagePaths.anonymous,
                    label: Values.signInAnonymous,
                    signInFunction: FirebaseUtils.signInAnonymous,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
