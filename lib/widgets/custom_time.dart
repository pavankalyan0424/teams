import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/intl_utils.dart';

class CustomTime extends StatefulWidget {
  const CustomTime({Key? key}) : super(key: key);

  @override
  _CustomTimeState createState() => _CustomTimeState();
}

class _CustomTimeState extends State<CustomTime> {
  late String _timeString;

  @override
  void initState() {
    _timeString = IntlUtils.getTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = IntlUtils.getTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      " $_timeString ",
      style: customTextStyle(20, Colors.white, FontWeight.w800),
    );
  }
}
