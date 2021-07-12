import 'package:flutter/material.dart';
import 'package:teams/screens/home_screen/chats_screen.dart';
import 'package:teams/screens/home_screen/profile_screen/profile_screen.dart';
import 'package:teams/screens/home_screen/side_drawer/tile.dart';
import 'package:teams/utils/firebase_utils.dart';

import 'head.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const Head(),
          Tile(
            title: "Profile",
            onTap: () {
              Navigator.maybePop(context).then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                ),
              );
            },
          ),
          Tile(
            title: 'Messages',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatsScreen(),
                ),
              );
            },
          ),
          Tile(
            title: 'Logout',
            onTap: () async {
              await FirebaseUtils.signOut();
            },
          ),
        ],
      ),
    );
  }
}
