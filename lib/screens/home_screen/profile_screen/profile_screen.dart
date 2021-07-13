import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/screens/home_screen/profile_screen/update_username.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/theme/gradients.dart';
import 'package:teams/utils/firebase_utils.dart';
import 'package:teams/widgets/custom_oval_bottom.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String photoURL = "";
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loaded
          ? Stack(
              children: [
                ClipPath(
                  clipper: CustomOvalBottom(),
                  child: Container(
                    width: width,
                    height: height / 2.5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: Gradients.cherry,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: height / 8, left: 20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: width / 2 - 64,
                    top: height / 3.1,
                  ),
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                      photoURL,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 300,
                      ),
                      Text(
                        userName,
                        style: customTextStyle(40, Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 40,
                        width: width / 2,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: Gradients.cherry,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => openEditProfileDialog(),
                          child: Center(
                            child: Text(
                              "Edit Profile",
                              style: customTextStyle(
                                17,
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void openEditProfileDialog() async {
    TextEditingController usernameController = TextEditingController();
    showDialog(
      builder: (context) => UpdateUserName(
        usernameController: usernameController,
      ),
      context: context,
    ).then((value) {
      setState(() {
        userName = usernameController.text;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    Map<String, dynamic> data = await FirebaseUtils.getUserDetails();
    setState(() {
      userName = data[StringConstants.username];
      photoURL = data[StringConstants.photoURL];
      loaded = true;
    });
  }
}
