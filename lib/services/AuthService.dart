import 'package:drb_app/models/MyUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(uid: user.uid);
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
