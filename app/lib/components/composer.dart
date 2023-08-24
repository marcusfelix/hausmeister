import 'dart:io';
import 'package:app/models/message.dart';
import 'package:app/models/profile.dart';
import 'package:app/models/ticket.dart';
import 'package:app/models/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:uuid/uuid.dart';

class Composer extends StatefulWidget {
  Composer({
    super.key,
    required this.unit,
    this.ticket
  });

  final Unit unit;
  final Ticket? ticket;

  @override
  State<Composer> createState() => _ComposerState();
}

class _ComposerState extends State<Composer> {
  final TextEditingController controller = TextEditingController();
  late Message _message;
  late User user;
  PlatformFile? _file;
  bool _working = false;
  Uuid uuid = const Uuid();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    _message = Message(
      id: '',
      body: '',
      unit: widget.unit.id,
      ticket: widget.ticket?.id, 
      metadata: [], 
      attachments: [],
      profile: Profile(
        uid: user.uid,
        name: user.displayName!,
        photo: user.photoURL
      ),
      created: DateTime.now()
    );
    super.initState();
  }

  void send() async {
    // Upload attachment if present
    if(_file != null) {
      _message.attachments.add(await upload());
    }

    // Update time
    _message.created = DateTime.now();

    // Send message
    await FirebaseFirestore.instance.collection("units").doc(widget.unit.id).collection("messages").add(_message.toMap());
    setState(() {
      controller.clear();
      _message.body = '';
      _message.attachments = [];
      _file = null;
    });
  }

  void pick() async {
    setState(() {
      _file = null;
    });

    // Pick a image file
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.image, 
      allowMultiple: false,
      withData: true
    );

    // Return if no file was picked
    if(file?.files.first == null) return;

    setState(() {
      _file = file?.files.first;
    });  
  }

  Future<String> upload() async {
    // Upload to Firebase Storage
    Reference ref = FirebaseStorage.instance.ref("attachments").child(uuid.v4());
    UploadTask task = ref.putData(
      _file!.bytes!, 
    );
    await task.whenComplete(() => null);

    // Get download URL
    final String url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? MediaQuery.of(context).viewInsets.bottom : MediaQuery.of(context).viewPadding.bottom),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (_) => send(),
        onChanged: (value) => setState(() => _message.body = value),
        decoration: InputDecoration(
          hintText: 'Write a message',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground
          ),
          isDense: true,
          border: InputBorder.none,
          prefixIcon: IconButton(
            onPressed: () => pick(),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(
                _file != null ? TablerIcons.circle_minus : TablerIcons.circle_plus, 
                size: 20,
              ),
            )
          ),
          suffixIcon: IconButton(
            onPressed: () => send(), 
            icon: _working ? const Padding(
              padding:  EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ) : const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(
                TablerIcons.circle_check, 
                size: 20,
              ),
            )
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none
        ),
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onBackground
        ),
      )
    );
  }
}