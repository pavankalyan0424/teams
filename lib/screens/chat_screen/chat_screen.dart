import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teams/screens/chat_screen/reciever_message.dart';
import 'package:teams/screens/chat_screen/sender_message.dart';
import 'package:teams/utils/firebase_utils.dart';

class ChatScreen extends StatefulWidget {
  final String localUid;
  final String conUid;

  const ChatScreen({Key? key, required this.localUid, required this.conUid})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(
            color: Colors.indigoAccent,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Messages(
            conUid: widget.conUid,
            localUid: widget.localUid,
          ),
          InputField(conUid: widget.conUid, localUid: widget.localUid),
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  const Messages({
    Key? key,
    required this.conUid,
    required this.localUid,
  }) : super(key: key);

  final String conUid;
  final String localUid;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseUtils.messageCollection
            .doc(conUid)
            .collection(conUid)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> totalMessages =
              snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: totalMessages.length,
            itemBuilder: (context, index) {
              dynamic data = totalMessages[index].data();
              return data["sentBy"] == localUid
                  ? SentMessage(
                      message: data["message"],
                      timestamp: data["timestamp"],
                    )
                  : ReceivedMessage(
                      message: data["message"],
                      timestamp: data["timestamp"],
                    );
            },
          );
        },
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController localTextController = TextEditingController();
  final String localUid;
  final String conUid;

  InputField({Key? key, required this.localUid, required this.conUid})
      : super(key: key);

  void sendMessage() {
    String message = localTextController.text;
    if (message.isNotEmpty) {
      FirebaseUtils.messageCollection.doc(conUid).collection(conUid).doc().set({
        "message": message,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "sentBy": localUid
      });
    }
    localTextController.text = "";
  }

  @override
  Widget build(BuildContext context) {
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
