import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onTap;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SnackBar snackBar = SnackBar(
          content: Row(
            children: [
              Text(
                "Loading....",
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
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        onTap();
      },
      child: Container(
        child: Center(
          child: Text(
            label,
            style: customTextStyle(20, Colors.white),
          ),
        ),
        width: double.maxFinite,
        height: 64,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF64B5F6),
              Color(0xFF90CAF9),
              Color(0xFF42A5F5),
            ],
          ),
        ),
      ),
    );
  }
}
