import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/theme/gradients.dart';
import 'package:teams/utils/firebase_utils.dart';

class UpdateUserName extends StatelessWidget {
  final TextEditingController usernameController;

  const UpdateUserName({Key? key, required this.usernameController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: TextFormField(
                controller: usernameController,
                style: customTextStyle(18, Colors.black),
                validator: (value) =>
                    value!.isEmpty ? "Username can't be empty" : "",
                decoration: InputDecoration(
                  labelText: "Update Username",
                  labelStyle: customTextStyle(
                    16,
                    Colors.grey,
                  ),
                ),
              ),
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
                onTap: () async {
                  if (usernameController.text.isNotEmpty) {
                    FirebaseUtils.userDoc
                        .update({StringConstants.username: usernameController.text});
                    Navigator.of(context).pop();
                  }
                },
                child: Center(
                  child: Text(
                    "Update now!",
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
      ),
    );
  }
}
