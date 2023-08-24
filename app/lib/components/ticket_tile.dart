import 'package:app/includes/ui.dart';
import 'package:app/models/ticket.dart';
import 'package:app/models/unit.dart';
import 'package:app/views/ticket_view.dart';
import 'package:flutter/material.dart';

class TicketTile extends StatelessWidget {
  const TicketTile({
    super.key,
    required this.unit,
    required this.ticket
  });

  final Unit unit;
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TicketView(
              unit: unit,
              ticket: ticket,
            )));
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon(ticket),
              size: 20,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          title: Text(
            ticket.title,
          ),
          subtitle: Text(
            ticket.description,
            maxLines: 1,
          ),
          trailing: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color(ticket),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const Divider(
          indent: 72,
          endIndent: 16,
          height: 2,
        ),
      ],
    );
  }
}