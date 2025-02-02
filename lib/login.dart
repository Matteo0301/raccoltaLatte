import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:raccoltalatte/auth.dart';
import 'package:raccoltalatte/collections/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raccoltalatte/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.username],
                    controller: userController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Username'),
                    keyboardType: TextInputType.name,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.password],
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: Column(children: [
                      ElevatedButton(
                        onPressed: () async {
                          String username = userController.text;
                          String password = passwordController.text;

                          try {
                            await login(username, password);
                            final LoggedUser? user = await getUserData();

                            if (user != null && context.mounted) {
                              FirebaseAnalytics.instance.logLogin();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          title: widget.title,
                                          username: user.username,
                                          admin: user.admin,
                                        )),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMessage =
                                "Impossibile effettuare il login";
                            switch (e.code) {
                              case "invalid-email":
                                errorMessage = "Email non valida";
                                break;
                              case "user-disabled":
                                errorMessage = "Utente disabilitato";
                                break;
                              case "user-not-found":
                                errorMessage = "Utente non trovato";
                                break;
                              case "wrong-password":
                                errorMessage = "Password errata";
                                break;
                              case "too-many-requests":
                                errorMessage = "Troppi login";
                                break;
                              case "network-request-failed":
                                errorMessage = "Impossibile connettersi";
                                break;
                            }
                            logAndShow(errorMessage);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Login', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await signInWithGoogle();

                            final LoggedUser? user = await getUserData();

                            if (user != null && context.mounted) {
                              FirebaseAnalytics.instance.logLogin();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          title: widget.title,
                                          username: user.username,
                                          admin: user.admin,
                                        )),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String errorMessage =
                                "Impossibile effettuare il login";
                            switch (e.code) {
                              case "invalid-email":
                                errorMessage = "Email non valida";
                                break;
                              case "user-disabled":
                                errorMessage = "Utente disabilitato";
                                break;
                              case "user-not-found":
                                errorMessage = "Utente non trovato";
                                break;
                              case "wrong-password":
                                errorMessage = "Password errata";
                                break;
                              case "too-many-requests":
                                errorMessage = "Troppi login";
                                break;
                              case "network-request-failed":
                                errorMessage = "Impossibile connettersi";
                                break;
                            }
                            logAndShow(errorMessage);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Login with Google',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
