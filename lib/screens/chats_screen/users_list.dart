import 'package:flutter/material.dart';
import 'package:teams/screens/chat_screen/chat_screen.dart';
import 'package:teams/theme/custom_textstyle.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    Key? key,
    required bool loading,
    required List<Map<String, dynamic>> users,
    required this.localUid,
  })  : _loading = loading,
        _users = users,
        super(key: key);

  final bool _loading;
  final List<Map<String, dynamic>> _users;
  final String localUid;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _users.isNotEmpty
              ? ListView.builder(
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
                )
              : Center(
                  child: Text(
                    "No Users Found",
                    style: customTextStyle(20, Colors.indigo),
                  ),
                ),
    );
  }
}
