import 'dart:math' as math; // import this

import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/widgets/custom_triangle.dart';

class ReceivedMessage extends StatelessWidget {
  final String message;
  final int timestamp;

  const ReceivedMessage(
      {Key? key, required this.message, required this.timestamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 18, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: CustomPaint(
                    painter: Triangle(
                      const Color(0xFFE0E0E0),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: customTextStyle(14, Colors.black),
                        ),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(timestamp)
                              .toString(),
                          style: customTextStyle(10, Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
