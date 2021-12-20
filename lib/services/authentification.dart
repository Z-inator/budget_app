import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  Stream<User?> get onAuthChanged {
    return auth.idTokenChanges();
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    try {
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user;
      if (userCredential.additionalUserInfo!.isNewUser && user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set({'displayName': user?.displayName});
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'account-exists-with-different-credential':
          return 'The account already exists using a different register method';
        case 'invalid-credential':
          return 'Invalid credentials. Try again.';
        default:
          return 'Error using Google Sign In. Try again.';
      }
    } catch (error) {
      return 'Error using Google Sign In. Try again.';
    }
    return 'Success signing in with Google';
  }

  Future signOut() async {
    return auth.signOut();
  }

  Future<void> buildNewUser(Map<String, dynamic> data) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update(data)
        .then((value) => print('Built new user'))
        .catchError((error) => print('Failed to build new user: $error'));
  }
}
