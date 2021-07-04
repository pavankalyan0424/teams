import 'package:flutter/material.dart';
import 'package:teams/screens/boarding_screen.dart';
import 'package:teams/utils/firebase_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () async {
          FirebaseUtils.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BoardingScreen(),
            ),
          );
        },
      ),
    );
  }
}
