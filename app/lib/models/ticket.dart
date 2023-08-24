import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  String title;
  String description;
  TicketStatus status;
  TicketType type;
  List<String> attachments = [];
  String user;
  String unit;
  DateTime created;
  DateTime updated;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.type,
    required this.attachments,
    required this.user,
    required this.unit,
    required this.created,
    required this.updated,
  });

  factory Ticket.fromJson(String uid, Map<String, dynamic> data) {
    return Ticket(
      id: uid,
      title: data['title'],
      description: data['description'],
      status: getStatus(data['status']),
      type: getType(data['type']),
      attachments: List<String>.from(data['attachment'] ?? []),
      user: data['user'],
      unit: data['unit'],
      created: DateTime.parse(data['created']),
      updated: DateTime.parse(data['updated']),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'status': status.name,
    'type': type.name,
    'attachments': attachments,
    'user': user,
    'unit': unit,
    'created': created.toIso8601String(),
    'updated': updated.toIso8601String(),
  };
}

enum TicketType {
  issue,
  request,
  other,
}

enum TicketStatus {
  open,
  aknowledge,
  closed,
}

TicketType getType(String type) {
  switch (type) {
    case 'issue':
      return TicketType.issue;

    case 'request':
      return TicketType.request;

    default:
      return TicketType.other;
  }
}

TicketStatus getStatus(String status) {
  switch (status) {
    case 'open':
      return TicketStatus.open;

    case 'acknowledge':
      return TicketStatus.aknowledge;

    default:
      return TicketStatus.closed;
  }
}

final ticketTransformer = StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<Ticket>>.fromHandlers(
  handleData: (snapshot, sink) {
    try {
      final tickets = snapshot.docs.map<Ticket>((e) => Ticket.fromJson(e.id, e.data())).toList();
      sink.add(tickets);
    } catch(e) {
      sink.addError(e);
    }
  }
);