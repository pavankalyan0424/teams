import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String username = "";
  String photoURL = "";

  @override
  void initState() {
    super.initState();
    FirebaseUtils.getUserDetails().then(updateVariables);
  }

  updateVariables(Map<String, dynamic> data) {
    setState(() {
      username = data["username"];
      photoURL = data["photoURL"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigoAccent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    photoURL,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Hi,",
                      style: customTextStyle(20, Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      username.substring(0, 5),
                      softWrap: true,
                      style: customTextStyle(17, Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Profile',
              style: customTextStyle(20, Colors.black),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text(
              'Chat',
              style: customTextStyle(20, Colors.black),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: customTextStyle(20, Colors.black),
            ),
            onTap: () async {
              await FirebaseUtils.signOut();
            },
          ),
        ],
      ),
    );
  }
}
