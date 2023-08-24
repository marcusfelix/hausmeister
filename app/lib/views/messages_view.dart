import 'package:app/components/message_tile.dart';
import 'package:app/models/message.dart';
import 'package:app/models/ticket.dart';
import 'package:app/models/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({
    super.key,
    required this.unit,
    this.ticket
  });

  final Unit unit;
  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ticket != null ? FirebaseFirestore.instance.collection("units").doc(unit.id).collection("messages").where("ticket", isEqualTo: ticket!.id).orderBy("created", descending: true).snapshots().transform(messagesTransformer) : FirebaseFirestore.instance.collection("units").doc(unit.id).collection("messages").where("ticket", isNull: true).orderBy("created", descending: true).snapshots().transform(messagesTransformer),
      builder: (context, messages) {
        return ListView(
          reverse: true,
          children: (messages.data ?? []).map<Widget>((message) => MessageTile(
            key: ValueKey(message.id),
            message: message,
          )).toList()
        );
      }
    );
  }

}