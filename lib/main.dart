import 'package:flutter/material.dart';
import 'package:teams/screens/boarding_screen.dart';
import 'package:teams/theme/theme.dart';
import 'package:teams/utils/firebase_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teams',
      theme: theme(),
      home: const BoardingScreen(),
    );
  }
}
