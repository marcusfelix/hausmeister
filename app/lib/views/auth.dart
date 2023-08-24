import 'package:app/components/create_account.dart';
import 'package:app/components/large_button.dart';
import 'package:app/components/login_with_email.dart';
import 'package:app/includes/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Auth extends StatelessWidget {
  const Auth({
    Key? key, 
    this.withNavigator = false
  }) : super(key: key);

  final bool withNavigator;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          translate("welcome_string"),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimaryContainer
        ),
        automaticallyImplyLeading: false,
        leading: withNavigator ? IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(TablerIcons.arrow_left),
        ) : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 32, 16, MediaQuery.of(context).viewPadding.bottom + 32),
            child: Column(
              children: ([]).map<Widget>((e) => Column(
                children: [
                  LargeButton(
                    label: "",
                    onPressed: () {}
                  ),
                  const SizedBox(height: 16),
                ],
              )).toList()..addAll([
                LargeButton(
                  label: translate("login_with_google_string"),
                  widget: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    children: [
                      Image.asset(
                        "assets/google.png", 
                        width: 24, 
                        height: 24
                      ),
                      Text(
                        translate("login_with_google_string"),
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w600, 
                          color: Colors.grey.shade700
                        ),
                      ),
                    ],
                  ),
                  rounded: true,
                  backgroundColor: Colors.grey.shade200,
                  onPressed: () {
                    // FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
                  }
                ),
                const SizedBox(height: 16),
                LargeButton(
                  label: translate("login_with_email_string"),
                  rounded: true,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context, 
                      isScrollControlled: true,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        margin: MediaQuery.of(context).viewInsets,
                        child: const LoginWithEmail()
                      )
                    ).then((value) => value != null && withNavigator ? Navigator.of(context).pop(value) : null);
                  }
                ),
                const SizedBox(height: 16),
                LargeButton(
                  label: translate("create_account_string"),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  color: Theme.of(context).colorScheme.onBackground,
                  rounded: true,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context, 
                      isScrollControlled: true,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        margin: MediaQuery.of(context).viewInsets,
                        child: const CreateAccount()
                      )
                    ).then((value) => value != null && withNavigator ? Navigator.of(context).pop(value) : null);
                  }
                )
              ]),
            )
          ),
        ],
      ),
    );
  }
}
