import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class Head extends StatefulWidget {
  const Head({
    Key? key,
  }) : super(key: key);

  @override
  State<Head> createState() => _HeadState();
}

class _HeadState extends State<Head> {
  String username = "Username";
  String photoURL =
      "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png";

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
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.indigoAccent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              photoURL,
            ),
          ),
          Text(
            username,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: customTextStyle(20,Colors.white),
          ),
        ],
      ),
    );
  }
}
