import 'package:app/components/large_button.dart';
import 'package:app/includes/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({
    Key? key
  }) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String _name = "";
  String _email = "";
  String _password = "";
  bool _working = false;

  Future<User?> create() async {
    setState(() => _working = true);
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email, 
        password: _password
      );

      await user.user?.updateDisplayName(_name);

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

  bool validate() => _name.isNotEmpty && regex.hasMatch(_email) && _password.isNotEmpty;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          translate("create_account_string"),
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: translate("name_string"),
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    onChanged: (String value) => setState(() => _name = value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: translate("email_string"),
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    onChanged: (String value) => setState(() => _email = value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: translate("password_string"),
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    onChanged: (String value) => setState(() => _password = value),
                  ),
                ),
              ],
            ),
          ),
          LargeButton(
            label: translate("create_account_string"),
            working: _working,
            viewPadding: true,
            onPressed: validate() ? () {
              create().then((value) => Navigator.of(context).pop(value));
            } : null,
          )
        ],
      ),
    );
  }

}
