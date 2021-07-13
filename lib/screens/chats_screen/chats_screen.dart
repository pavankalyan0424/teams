import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/screens/chats_screen/users_list.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController searchController = TextEditingController();
  String localUid = FirebaseUtils.userId();
  List<Map<String, dynamic>> _users = [];
  final List<Map<String, dynamic>> _chattedUsers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    await FirebaseUtils.messageCollection
        .where(StringConstants.users, arrayContains: localUid)
        .get()
        .then((collectionSnapshot) {
      for (var documentSnapshot in collectionSnapshot.docs) {
        dynamic data = documentSnapshot.data();
        String remoteUid = data[StringConstants.users]
            .singleWhere((e) => e.toString() != localUid)
            .toString();
        FirebaseUtils.userCollection.doc(remoteUid).get().then((ds) {
          dynamic data = ds.data();
          _chattedUsers.add(data);
          setState(() {
            _users.add(data);
          });
        });
      }
    });
    setState(() {
      _loading = false;
    });
  }

  void resetMessages() {
    String search = searchController.text;
    if (search.isEmpty) {
      _users.clear();
      for (var data in _chattedUsers) {
        setState(() {
          _users.add(data);
        });
      }
    }
  }

  void searchMessage() async {
    String search = searchController.text;
    setState(() {
      _loading = true;
    });
    _users.clear();
    for (var data in _chattedUsers) {
      _users.add(data);
    }
    if (search != "") {
      _users
          .retainWhere((element) => element[StringConstants.username].contains(search));
      await FirebaseUtils.userCollection
          .where(StringConstants.username, isEqualTo: search)
          .get()
          .then((collectionSnapshot) {
        for (var documentSnapshot in collectionSnapshot.docs) {
          dynamic data = documentSnapshot.data();
          if (!_users.contains(data) && data[StringConstants.username] == search) {
            _users.add(data);
          }
        }
      });
    }
    setState(() {
      _loading = false;
      _users = _users;
    });
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onEditingComplete: () => searchMessage(),
              onChanged: (value) => resetMessages(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Search by Username",
              ),
            ),
            UsersList(
              loading: _loading,
              users: _users,
              localUid: localUid,
              emptyQuery: searchController.text.isEmpty,
            )
          ],
        ),
      ),
    );
  }
}
