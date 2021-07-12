import 'package:flutter/material.dart';
import 'package:teams/utils/firebase_utils.dart';

class InputField extends StatelessWidget {
  final TextEditingController localTextController = TextEditingController();
  final String localUid;
  final String conId;

  InputField({
    Key? key,
    required this.localUid,
    required this.conId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void sendMessage() {
      String message = localTextController.text;
      if (message.isNotEmpty) {
        FirebaseUtils.messageCollection.doc(conId).collection(conId).doc().set({
          "message": message,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "sentBy": localUid
        });
      }
      localTextController.text = "";
      FocusScope.of(context).unfocus();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              autofocus: true,
              onSubmitted: (value) => sendMessage(),
              controller: localTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Type a message",
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: sendMessage,
              child: const Icon(
                Icons.arrow_forward_sharp,
                color: Colors.white,
                size: 25.0,
              ),
              shape: const CircleBorder(),
              fillColor: Colors.indigoAccent,
            ),
          )
        ],
      ),
    );
  }
}
