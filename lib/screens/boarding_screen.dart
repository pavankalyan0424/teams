import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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
  late StreamSubscription<User?> listen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    addFirebaseListener();
  }

  addFirebaseListener() {
    listen = FirebaseUtils.auth.authStateChanges().listen((user) {
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
  void dispose() {
    super.dispose();
    listen.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isSigned) {
      if (state == AppLifecycleState.resumed) {
        FirebaseUtils.userCollection
            .doc(FirebaseUtils.userId())
            .update({"online": true});
      } else {
        FirebaseUtils.userCollection
            .doc(FirebaseUtils.userId()).update({"online": false});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isSigned ? const HomeScreen() : const IntroScreen();
  }
}
