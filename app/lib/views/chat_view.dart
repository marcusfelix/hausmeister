import 'package:app/components/composer.dart';
import 'package:app/models/ticket.dart';
import 'package:app/models/unit.dart';
import 'package:app/views/messages_view.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    Key? key,
    required this.unit,
    this.ticket
  }) : super(key: key);

  final Unit unit;
  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessagesView(
        unit: unit,
        ticket: ticket,
      ),
      bottomNavigationBar: Composer(
        unit: unit,
        ticket: ticket,
      )
    );
  }
}