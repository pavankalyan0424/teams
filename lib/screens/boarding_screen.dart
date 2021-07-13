import 'package:flutter/material.dart';
import 'package:teams/screens/home_screen/home_screen.dart';
import 'package:teams/screens/intro_screen.dart';
import 'package:teams/utils/firebase_utils.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen>
    with WidgetsBindingObserver {
  bool _isSigned = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isSigned) {
      if (state == AppLifecycleState.resumed) {
        FirebaseUtils.userCollection.doc(FirebaseUtils.auth.currentUser!.uid).update({
          "online":true
        });
      } else {
        FirebaseUtils.userCollection.doc(FirebaseUtils.auth.currentUser!.uid).update({
          "online":false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isSigned ? const HomeScreen() : const IntroScreen();
  }
}
