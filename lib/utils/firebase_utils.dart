import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUtils {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static CollectionReference roomCollection =
      FirebaseFirestore.instance.collection("rooms");
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static Future googleSignIn() async {
    GoogleSignInAccount _googleSignInAccount;
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    // if (googleSignInAccount == null) return;
    _googleSignInAccount = googleSignInAccount!;
    final GoogleSignInAuthentication googleAuth =
        await _googleSignInAccount.authentication;
    final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await auth.signInWithCredential(credentials);
    final User user = auth.currentUser!;
    print(user.uid);
    print(user.displayName);
    return user;
  }

  static googleSignOut() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }
}

//logo
//Hey there, welcome back
//login to your account to continue
