import 'package:app/components/ticket_tile.dart';
import 'package:app/models/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../models/ticket.dart';

class Tickets extends StatelessWidget {
  Tickets({
    Key? key,
    required this.unit
  }) : super(key: key);

  final Unit unit;

  ValueNotifier<String> search = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("units").doc(unit.id).collection("tickets").where("unit", isEqualTo: unit.id).snapshots().transform(ticketTransformer),
      builder: (context, tickets) {
        return ValueListenableBuilder(
          valueListenable: search,
          builder: (context, filter, _) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search tickets',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5)
                      ),
                      prefixIcon: const Icon(TablerIcons.search),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimaryContainer
                    ),
                    onChanged: (value) {
                      search.value = value;
                      search.notifyListeners();
                    },
                  )
                ),
                ...(tickets.data ?? []).where((e) => filter != "" ? e.title.toLowerCase().contains(filter.toLowerCase()) : true).map((ticket) => TicketTile(
                  unit: unit,
                  ticket: ticket
                )).toList()
              ]
            );
          }
        );
      }
    );
  }
}