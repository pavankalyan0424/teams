import 'package:flutter/material.dart';
import 'package:teams/screens/home_screen.dart';
import 'package:teams/utils/firebase_utils.dart';

import 'intro_screen.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  bool _isSigned = false;

  @override
  void initState() {
    super.initState();
    FirebaseUtils.auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          _isSigned = true;
        });
      } else {
        setState(() {
          _isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSigned ? const HomeScreen() : IntroScreen();
  }
}
