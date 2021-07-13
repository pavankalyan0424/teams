import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teams/constants/image_paths.dart';
import 'package:teams/constants/string_constants.dart';

class FirebaseUtils {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection(StringConstants.users);
  static CollectionReference roomCollection =
      FirebaseFirestore.instance.collection(StringConstants.rooms);
  static CollectionReference messageCollection =
      FirebaseFirestore.instance.collection(StringConstants.messages);

  static DocumentReference userDoc = userCollection.doc(userId());

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static Future<User> googleSignIn() async {
    GoogleSignInAccount _googleSignInAccount;
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    _googleSignInAccount = googleSignInAccount!;
    final GoogleSignInAuthentication googleAuth =
        await _googleSignInAccount.authentication;
    final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await auth.signInWithCredential(credentials);
    final User user = auth.currentUser!;
    storeUserDetails(user);
    return user;
  }

  static signOut() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    await auth.signOut();
  }

  static Future<User> signInAnonymous() async {
    await auth.signInAnonymously();
    final User user = auth.currentUser!;
    storeUserDetails(user);
    return user;
  }

  static String userId() {
    return auth.currentUser!.uid;
  }

  static Future<void> storeUserDetails(User user) async {
    //To generate random number for avoiding common names during guest login
    Random random = Random();
    userCollection.doc(user.uid).get().then((documentSnapshot) {
      if (!documentSnapshot.exists) {
        userCollection.doc(user.uid).set({
          StringConstants.username:
              user.displayName ?? "Guest${random.nextInt(900) + 100}",
          StringConstants.uid: user.uid,
          StringConstants.email: user.email ?? "guest@guest.com",
          StringConstants.photoURL: user.photoURL ?? ImagePaths.anonymousFromNet,
          StringConstants.online: true,
        });
      } else {
        userCollection.doc(user.uid).update({
          StringConstants.online: true,
        });
      }
    });
  }

  static Future<Map<String, dynamic>> getUserDetails() async {
    Map<String, dynamic> data = {};
    await userCollection.doc(userId()).get().then((documentSnapshot) {
      dynamic _data = documentSnapshot.data();
      data = _data.cast<String, dynamic>();
    });
    return data;
  }
}
