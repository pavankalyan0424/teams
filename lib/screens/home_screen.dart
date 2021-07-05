import 'package:flutter/material.dart';
import 'package:teams/constants/variables.dart';
import 'package:teams/screens/boarding_screen.dart';
import 'package:teams/screens/create_meeting_screen.dart';
import 'package:teams/screens/join_meeting_screen.dart';
import 'package:teams/utils/firebase_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final List pages = [const JoinMeetingScreen(), const CreateMeetingScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseUtils.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BoardingScreen(),
                ),
              );
            },
            child: Text(
              "Logout",
              style: myStyle(17, Colors.black),
            ),
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        selectedLabelStyle: myStyle(17, Colors.blue),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: myStyle(17, Colors.black),
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: 32,
            ),
            label: "Join",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.meeting_room,
              size: 32,
            ),
            label: "Create",
          ),
        ],
      ),
    );
  }
}
