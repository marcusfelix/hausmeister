import 'package:app/components/large_button.dart';
import 'package:app/includes/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {

  String _email = "";
  String _password = "";
  bool _working = false;

  Future<User?> login() async {
    setState(() => _working = true);
    try {
      // Login with email and password
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email, 
        password: _password
      );

      return user.user;
    } on FirebaseAuthException catch(e){
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.message ?? translate("unknown_error_string"),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onErrorContainer
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer
      ));
    }
    setState(() => _working = false);
    return null;
  }

  void forgot() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate("password_reset_string")),
        content: Text(translate("you_will_receive_email_string")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              translate("cancel_string").toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              // service.collection("users").requestPasswordReset(_email).then((value) => Navigator.of(context).pop());
            },
            child: Text(translate("cancel_string").toUpperCase()),
          )
        ],
      ),
    );
  }

  bool validate() => (validateEmail(_email) && _password.isNotEmpty);

  bool validateEmail(String email) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          translate("login_with_email_string"),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(TablerIcons.arrow_left),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: TextFormField(
                      key: const Key("email"),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: translate("email_string"),
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      onChanged: (String value) => setState(() => _email = value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextFormField(
                      key: const Key("password"),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: translate("password_string"),
                      ),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      onChanged: (String value) => setState(() => _password = value),
                    ),
                  ),
                  validateEmail(_email) ? TextButton(
                    onPressed: () => forgot(), 
                    child: Text(translate("forgot_password_string").toUpperCase())) : Container()
                ],
              ),
            ),
          ),
          LargeButton(
            label: translate("login_string"),
            working: _working,
            viewPadding: true,
            onPressed: validate() ? () {
              login().then((auth) {
                if(auth != null){
                  Navigator.of(context).pop(auth);
                }
              });
            } : null,
          ),
        ],
      ),
    );
  }

}
