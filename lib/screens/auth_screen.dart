import 'package:flutter/material.dart';
import 'package:teams/constants/variables.dart';
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
      backgroundColor: Colors.grey[250],
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
                      "assets/images/teams_icon.jpg",
                      height: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hi There!!!",
                    style: myStyle(22, Colors.white, FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Login to your account to continue",
                    style: myStyle(17, Colors.white, FontWeight.w800),
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
                    imagePath: "assets/images/google_icon.png",
                    label: "Sign in with Google",
                    signInFunction: FirebaseUtils.googleSignIn,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SignInButton(
                    imagePath: "assets/images/anonymous.jpg",
                    label: "Sign in Anonymous",
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

class SignInButton extends StatelessWidget {
  final Function signInFunction;
  final String imagePath;
  final String label;

  const SignInButton(
      {Key? key,
      required this.signInFunction,
      required this.label,
      required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        try {
          SnackBar snackBar = SnackBar(
            content: Row(
              children: [
                Text(
                  "Loading....",
                  style: myStyle(
                    20,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const CircularProgressIndicator(),
              ],
            ),
            duration: const Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await signInFunction();
          Navigator.pop(context);
        } catch (e) {
          SnackBar snackBar = SnackBar(
            content: Text(
              "Oops, Please Try Again",
              style: myStyle(
                20,
              ),
            ),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(20),
        width: double.maxFinite,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      imagePath,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                label,
                style: myStyle(
                  20.0,
                  Colors.white,
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
