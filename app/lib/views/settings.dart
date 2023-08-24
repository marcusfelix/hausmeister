import 'dart:convert';
import 'dart:io';

import 'package:app/components/login_with_email.dart';
import 'package:app/includes/translator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String _name;
  late String _email;
  late String? _photo;
  bool _working = false;

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser!;
    _email = user.email!;
    _name = user.displayName ?? "";
    _photo = user.photoURL != null ? user.photoURL! : null;
    super.initState();
  }

  Future<void> save() async {
    // Upload the image
    await FirebaseAuth.instance.currentUser!.updateDisplayName(_name);
  }

  Future upload() async {
    setState(() => _working = true);

    // Pick a image file
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.image, 
      allowMultiple: false,
      withData: true
    );

    // Return if no file was picked
    if(file?.files.first == null) return;

    // Upload to Firebase Storage
    Reference ref = FirebaseStorage.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask task = ref.putData(
      file!.files.first.bytes!, 
    );
    await task.whenComplete(() => null);
    
    // Save the download url to the user
    final String url = await ref.getDownloadURL();
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);

    setState(() {
      _photo = url;
      _working = false;
    });
  }

  Future removePhoto() async {
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(null);
    setState(() {
      _photo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(TablerIcons.arrow_left),
        ),
        title: Text(
          translate("settings_string"),
        ),
        actions: [
          IconButton(
            onPressed: _working ? null : () {
              setState(() => _working = true);
              save().then((value) => Navigator.of(context).pop());
              setState(() => _working = false);
            }, 
            icon: _working ? SizedBox(
              width: 24, 
              height: 24, 
              child: CircularProgressIndicator(
                strokeWidth: 2, 
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary)
              )
            ) : const Icon(
              TablerIcons.circle_check, 
              size: 28
            )
          )
        ],
      ),
      body: ListView(padding: const EdgeInsets.symmetric(vertical: 16), children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              backgroundImage: _photo != null ? NetworkImage(_photo.toString()) : null,
            ),
            title: Text(translate("upload_profile_image_string")),
            onTap: () => upload(),
            trailing: IconButton(
              onPressed: () => removePhoto(),
              icon: Icon(
                TablerIcons.x,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3)
              ),
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextFormField(
            initialValue: _name,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: translate("name_string")
            ),
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextFormField(
            initialValue: _email,
            keyboardType: TextInputType.emailAddress,
            enabled: false,
            decoration: InputDecoration(
              labelText: translate("email_string")
            ),
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        const SizedBox(height: 42),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextButton(
            onPressed: () => changePassword(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(
              translate("change_password_string").toUpperCase(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextButton(
            onPressed: () => askToLogout(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(
              translate("logout_string").toUpperCase(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextButton(
            onPressed: () => delete(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.transparent,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(
              translate("delete_account_string").toUpperCase(),
            ),
          ),
        ),
      ]),
    );
  }

  void changePassword() {
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
              FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value) => Navigator.of(context).pop());
            },
            child: Text(translate("continue_string").toUpperCase()),
          )
        ],
      ),
    );
  }

  void askToLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate("logout_string")),
        content: Text(translate("are_you_sure_question_string")),
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
              FirebaseAuth.instance.signOut().then((_) => Navigator.of(context).pop());
            },
            child: Text(translate("logout_string").toUpperCase()),
          )
        ],
      ),
    );
  }

  void delete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate("delete_account_question_string")),
        content: Text(translate("this_action_will_delete_string")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              translate("cancel_string").toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Reauthenticate
              await showModalBottomSheet(
                context: context, 
                isScrollControlled: true,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: MediaQuery.of(context).viewInsets,
                  child: const LoginWithEmail()
                )
              ).then((value) {
                if(value != null){
                  FirebaseAuth.instance.currentUser!.delete();
                  FirebaseAuth.instance.signOut();
                }
              });
            },
            child: Text(
              translate("delete_string").toUpperCase(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
        ],
      ),
    );
  }

  void clear() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate("clear_local_data_question_string")),
        content: Text(translate("this_action_will_clear_string")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              translate("cancel_string").toUpperCase(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Delete all local files
              // List<FileSystemEntity> files = services.directory?.listSync() ?? [];
              // for (FileSystemEntity file in files) {
              //   try {
              //     file.deleteSync();
              //   } catch(e){
              //     print(e);
              //   }
              // }
              Navigator.of(context).pop();
            },
            child: Text(
              translate("clear_string").toUpperCase(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
        ],
      ),
    );
    
  }
}
