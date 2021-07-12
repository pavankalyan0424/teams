import 'package:flutter/material.dart';
import 'package:teams/screens/chat_screen/chat_screen.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  String localUid = FirebaseUtils.auth.currentUser!.uid;
  final List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    FirebaseUtils.messageCollection
        .where("users", arrayContains: localUid)
        .get()
        .then((collectionSnapshot) {
      for (var documentSnapshot in collectionSnapshot.docs) {
        dynamic data = documentSnapshot.data();
        String remoteUid = data["users"]
            .singleWhere((e) => e.toString() != localUid)
            .toString();
        FirebaseUtils.userCollection.doc(remoteUid).get().then((ds) {
          dynamic data = ds.data();
          setState(() {
            _users.add(data.cast<String, dynamic>());
          });
        });
      }
    }).then(
      (value) => setState(() {
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: customTextStyle(20, Colors.indigo, FontWeight.w500),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _users.length,
                      itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  localUid: localUid,
                                  remoteUid: _users[index]["uid"],
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                _users[index]["photoURL"],
                              ),
                            ),
                            title: Text(
                              _users[index]["username"],
                              style: customTextStyle(20, Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
