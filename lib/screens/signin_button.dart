import 'package:flutter/material.dart';
import 'package:teams/constants/values.dart';
import 'package:teams/theme/custom_textstyle.dart';

class SignInButton extends StatelessWidget {
  final Function signInFunction;
  final String imagePath;
  final String label;

  const SignInButton(
      {Key? key,
      required this.signInFunction,
      required this.label,
      required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          SnackBar snackBar = SnackBar(
            content: Row(
              children: [
                Text(
                  Values.loading,
                  style: customTextStyle(
                    20,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const CircularProgressIndicator(),
              ],
            ),
            duration: const Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await signInFunction();
          Navigator.pop(context);
        } catch (e) {
          SnackBar snackBar = SnackBar(
            content: Text(
              Values.pleaseTryAgain,
              style: customTextStyle(
                20,
              ),
            ),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(20),
        width: double.maxFinite,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      imagePath,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                label,
                style: customTextStyle(
                  20.0,
                  Colors.white,
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
