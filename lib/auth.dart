import 'package:raccoltalatte/requests.dart';
import 'package:firebase_auth/firebase_auth.dart';

const domain = '@gmail.com';

Future<void> login(String username, String password) async {
  final String email = username + domain;
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

Future<void> logout() async {
  FirebaseAuth.instance.signOut();
}

class LoggedUser {
  final String username;
  final bool admin;

  const LoggedUser({required this.username, required this.admin});

  factory LoggedUser.fromJson(Map<String, dynamic> json) {
    return LoggedUser(username: json['username'], admin: json['admin']);
  }
}

Future<LoggedUser?> getUserData() async {
  return (FirebaseAuth.instance.currentUser != null)
      ? (LoggedUser.fromJson((await db
              .collection('users')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .get())
          .docs
          .first
          .data()))
      : null;
}
