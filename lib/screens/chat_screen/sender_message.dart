import 'package:flutter/material.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/widgets/custom_triangle.dart';

class SentMessage extends StatelessWidget {
  final String message;
  final int timestamp;

  const SentMessage({
    Key? key,
    required this.message,
    required this.timestamp
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: customTextStyle(14, Colors.white),
                        ),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(timestamp)
                              .toString(),
                          style: customTextStyle(10, Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomPaint(
                  painter: Triangle(
                    const Color(0xFF212121),
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
