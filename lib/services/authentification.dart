import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get user {
    return auth.currentUser;
  }

  Stream<User?> get onAuthChanged {
    return auth.idTokenChanges();
  }
}
