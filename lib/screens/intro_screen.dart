import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:teams/constants/variables.dart';

import 'auth_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      onDone: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      },
      onSkip: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      },
      showSkipButton: true,
      skip: const Icon(
        Icons.skip_next,
        size: 45,
      ),
      next: const Icon(
        Icons.arrow_forward_ios,
        size: 45,
      ),
      done: Text(
        "Done",
        style: myStyle(
          20,
          Colors.black,
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "Welcome to Teams, the best video conference app",
          image: Center(
            child: Image.asset(
              "assets/images/welcome.png",
              height: 175,
            ),
          ),
          decoration: PageDecoration(
            bodyTextStyle: myStyle(
              20,
              Colors.black,
            ),
            titleTextStyle: myStyle(
              20,
              Colors.black,
            ),
          ),
        ),
        PageViewModel(
          title: "Join or Start Meetings",
          body: "Easy to use interface, join or start meetings in a fast time",
          image: Center(
            child: Image.asset(
              "assets/images/conference.png",
              height: 175,
            ),
          ),
          decoration: PageDecoration(
            bodyTextStyle: myStyle(
              20,
              Colors.black,
            ),
            titleTextStyle: myStyle(
              20,
              Colors.black,
            ),
          ),
        ),
        PageViewModel(
          title: "Security",
          body:
              "Your Security is important for us. Our servers are secure and reliable",
          image: Center(
            child: Image.asset(
              "assets/images/secure.jpg",
              height: 175,
            ),
          ),
          decoration: PageDecoration(
            bodyTextStyle: myStyle(
              20,
              Colors.black,
            ),
            titleTextStyle: myStyle(
              20,
              Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
