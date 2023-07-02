import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drb_app/models/MyUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    return MyUser(uid: user.uid);
  }

  Future<String?> getName() async {
    String uid = _firebaseAuth.currentUser!.uid;
    var doc = await db.collection("Users").doc(uid).get();
    return doc.data()!['Name'];
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<User?> signIn(
    String email,
    String password,
  ) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return cred.user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
