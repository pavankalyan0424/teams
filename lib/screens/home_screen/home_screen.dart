import 'package:flutter/material.dart';
import 'package:teams/screens/create_meeting_screen/create_meeting_screen.dart';
import 'package:teams/screens/home_screen/side_drawer/side_drawer.dart';
import 'package:teams/screens/join_meeting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List _pages = [const JoinMeetingScreen(), const CreateMeetingScreen()];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const SideDrawer(),
      body: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: height*0.07, left: 20),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.view_headline,
                    color: _currentIndex == 0 ? Colors.white : Colors.indigo,
                    size: 40,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() {
          _currentIndex = value;
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
