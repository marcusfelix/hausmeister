import 'dart:async';

import 'package:app/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  String body;
  List<Map<String, dynamic>> metadata;
  List<String> attachments;
  String? ticket;
  Profile profile;
  String unit;
  DateTime created;

  Message({
    required this.id,
    required this.body,
    required this.metadata,
    required this.attachments,
    this.ticket,
    required this.profile,
    required this.unit,
    required this.created,
  });

  factory Message.fromJson(String id, Map<String, dynamic> data) {
    try {
      return Message(
        id: id,
        body: data['body'],
        metadata: List<Map<String, dynamic>>.from(data['metadata'] ?? []),
        attachments: List<String>.from(data['attachment'] ?? []),
        ticket: null,
        profile: Profile.fromJson(data['profile']['uid'], data['profile']),
        unit: data['unit'],
        created: DateTime.parse(data['created']),
      );
    } catch(e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() => {
    'body': body,
    'metadata': metadata,
    'attachment': attachments,
    'ticket': ticket,
    'profile': profile.toMap(),
    'unit': unit,
    'created': created.toIso8601String(),
  };
}

final messagesTransformer = StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<Message>>.fromHandlers(
  handleData: (snapshot, sink) {
    try {
      sink.add(snapshot.docs.map<Message>((e) => Message.fromJson(e.id, e.data())).toList());
    } catch(e) {
      sink.addError(e);
    }
  }
);