import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teams/constants/string_constants.dart';
import 'package:teams/theme/custom_textstyle.dart';
import 'package:teams/utils/firebase_utils.dart';

class RemoteUserTile extends StatefulWidget {
  final String remoteUid;

  const RemoteUserTile({Key? key, required this.remoteUid}) : super(key: key);

  @override
  _RemoteUserTileState createState() => _RemoteUserTileState();
}

class _RemoteUserTileState extends State<RemoteUserTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseUtils.userCollection.doc(widget.remoteUid).snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
        if (!snapshot.hasData) {
          return Text(
            "Loading",
            style: customTextStyle(17),
          );
        }
        var userDocument = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              userDocument![StringConstants.photoURL],
            ),
          ),
          title: Text(
            userDocument[StringConstants.username],
            style: customTextStyle(14, Colors.indigo),
          ),
          subtitle: Text(
            userDocument[StringConstants.online] ? "online" : "Offline",
            style: customTextStyle(
                10,
                userDocument[StringConstants.online]
                    ? Colors.green
                    : Colors.red),
          ),
        );
      },
    );
  }
}
