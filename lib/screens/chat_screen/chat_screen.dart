import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teams/screens/chat_screen/reciever_message.dart';
import 'package:teams/screens/chat_screen/sender_message.dart';
import 'package:teams/utils/firebase_utils.dart';

class ChatScreen extends StatefulWidget {
  final String localUid;
  final String remoteUid;

  const ChatScreen({Key? key, required this.localUid, required this.remoteUid})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController localTextController = TextEditingController();
  List<Map<String, dynamic>> totalMessages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<List<Map<String, dynamic>>> getMessages(
      String primaryId, String secondaryId, bool sentByMe) async {
    List<Map<String, dynamic>> messages = [];
    await FirebaseUtils.userCollection
        .doc(primaryId)
        .collection("chat")
        .doc(secondaryId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .get()
        .then((collectionSnapshot) {
      for (var documentSnapshot in collectionSnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data();
        data["sentByMe"] = sentByMe;
        messages.add(data);
      }
    });
    return messages;
  }

  void addListenerToRemote() {
    FirebaseUtils.userCollection
        .doc(widget.remoteUid)
        .collection("chat")
        .doc(widget.localUid)
        .collection("messages")
        .snapshots()
        .forEach((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          dynamic data = change.doc.data();
          data["sentByMe"] = false;
          totalMessages.add(data);
        }
      }
    });
  }

  void loadMessages() async {
    //loading local messages
    totalMessages
        .addAll(await getMessages(widget.localUid, widget.remoteUid, true));

    //loading remote messages
    totalMessages
        .addAll(await getMessages(widget.remoteUid, widget.localUid, false));

    //combining all messages and sorting them
    setState(() {
      totalMessages.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));
    });

    //listening to remote messages
    addListenerToRemote();
  }

  sendMessage() {
    String message = localTextController.text;
    if (message.isNotEmpty) {
      Map<String, dynamic> data = {
        "message": localTextController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      };

      localTextController.text = "";
      FocusScope.of(context).unfocus();
      FirebaseUtils.userCollection
          .doc(widget.localUid)
          .collection("chat")
          .doc(widget.remoteUid)
          .collection("messages")
          .doc()
          .set(data);
      data["sentByMe"] = true;
      setState(() {
        totalMessages.add(data);
      });
    }
  }

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
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, index) => totalMessages[index]["sentByMe"]
                ? SentMessage(message: totalMessages[index]["message"])
                : ReceivedMessage(message: totalMessages[index]["message"]),
            itemCount: totalMessages.length,
            padding: const EdgeInsets.all(10),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
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
            ),
          )
        ],
      ),
    );
  }
}
