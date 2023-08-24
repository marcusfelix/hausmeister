import 'package:app/components/documents.dart';
import 'package:app/components/empty_tickets.dart';
import 'package:app/components/tenants.dart';
import 'package:app/components/ticket_tile.dart';
import 'package:app/models/ticket.dart';
import 'package:app/models/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dash extends StatelessWidget {
  const Dash({
    Key? key,
    required this.unit
  }) : super(key: key);

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Hallo, ${FirebaseAuth.instance.currentUser!.displayName}!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2
                    ),
                  ),
                  child: Text(
                    unit.unit,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tenants(
            unit: unit
          ),
          Documents(
            unit: unit,
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection("units").doc(unit.id).collection("tickets").get().then((value) => value.docs.map((e) => Ticket.fromJson(e.id, e.data())).toList()),
            builder: (context, tickets) {
              return Column(
                children: (tickets.data ?? []).isNotEmpty ? tickets.data!.map<Widget>((Ticket ticket) => TicketTile(
                  unit: unit,
                  ticket: ticket
                )).toList() : [
                  const EmptyTickets()
                ]
              );
            }
          ),
          const SizedBox(height: 80),
        ],
      )
    );
  }
}