import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerUser(UserModel user, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      String firebaseUid = credential.user!.uid;
      Map<String, dynamic> userData = user.toMap();
      userData['uid'] = firebaseUid;

      await _firestore
          .collection('users')
          .doc(firebaseUid)
          .set(userData);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "A apărut o eroare la înregistrare.";
    }
  }

  Future<UserCredential> loginUser(String email, String password) async {
  try {
    
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    throw e.message ?? "A apărut o eroare la autentificare.";
  }
}
Future<void> logOut() async {
  try {
    await _auth.signOut();
  } catch (e) {
    throw "Eroare la deconectare: $e";
  }
}
}