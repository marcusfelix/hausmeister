import 'dart:convert';
import 'dart:io';
import 'package:app/components/bottom_button.dart';
import 'package:app/includes/translator.dart';
import 'package:app/models/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:uuid/uuid.dart';

import '../includes/ui.dart';
import '../models/ticket.dart';

class TicketEdit extends StatefulWidget {
  const TicketEdit({
    Key? key,
    this.ticket,
    required this.unit
  }) : super(key: key);

  final Ticket? ticket;
  final Unit unit;

  @override
  State<TicketEdit> createState() => _TicketEditState();
}

class _TicketEditState extends State<TicketEdit> {
  late User user;
  late Ticket _ticket;
  bool _working = false;
  Uuid uuid = const Uuid();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    _ticket = widget.ticket ?? Ticket(
      id: "", 
      title: "", 
      description: "", 
      status: TicketStatus.open, 
      type: TicketType.issue, 
      attachments: [], 
      user: user.uid,
      unit: widget.unit.id,
      created: DateTime.now(), 
      updated: DateTime.now()
    );
    super.initState();
  }

  save() async {
    setState(() => _working = true);
    await FirebaseFirestore.instance.collection("units").doc(widget.unit.id).collection("tickets").doc().set(_ticket.toMap()).then((value) => Navigator.pop(context));
    setState(() => _working = false);
  }

  upload() async {
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
    Reference ref = FirebaseStorage.instance.ref("attachments").child(uuid.v4());
    UploadTask task = ref.putData(
      file!.files.first.bytes!, 
    );
    await task.whenComplete(() => null);
    
    // Save the download url to the user
    final String url = await ref.getDownloadURL();

    setState(() {
      _ticket.attachments.add(url);
      _working = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(TablerIcons.arrow_left)
        ),
        title: Text(widget.ticket != null ? translate("edit_ticket_string") : translate("new_ticket_string")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon(_ticket),
                size: 20,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            title: Text(translate("${_ticket.type.name}_string")),
            trailing: PopupMenuButton(
              icon: const Icon(TablerIcons.chevron_down),
              itemBuilder: (context) => TicketType.values.map((e) => PopupMenuItem(
                value: e,
                child: Text(translate("${e.name}_string")),
              )).toList(),
              onSelected: (TicketType type) => setState(() => _ticket.type = type),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                label: Text(translate("short_title_string")),
              ),
              style: const TextStyle(
                fontSize: 14
              ),
              onChanged: (String value) => setState(() => _ticket.title = value),
            )
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                label: Text(translate("complete_description_string")),
              ),
              style: const TextStyle(
                fontSize: 14
              ),
              minLines: 1,
              maxLines: 5,
              onChanged: (String value) => setState(() => _ticket.description = value),
            )
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 15,
              children: _ticket.attachments.map<Widget>((file) => SizedBox(
                width: (MediaQuery.of(context).size.width - 58) / 2,
                height: (MediaQuery.of(context).size.width - 58) / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    child: InkWell(
                      onTap: (){
                        setState(() => _ticket.attachments.remove(file));
                      },
                      child: Image.network(
                        file,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )).toList()..add(_ticket.attachments.length < 5 ? SizedBox(
                width: (MediaQuery.of(context).size.width - 58) / 2,
                height: (MediaQuery.of(context).size.width - 58) / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    child: InkWell(
                      onTap: () => upload(),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer
                        ),
                        child: Icon(
                          TablerIcons.plus,
                          size: 24,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Container())
            )
          )
        ],
      ),
      bottomNavigationBar: BottomButton(
        text: translate("save_string"),
        onTap: () => save()
      ),
    );
  }
}